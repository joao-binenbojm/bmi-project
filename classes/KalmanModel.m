classdef KalmanModel
    %KALMANMODEL Model that accounts for learning matrices A and H
    
    properties
        bw
        delay
        x_avg
        y_avg
        A
        H
        Q
        W
        P_past
        x_past
        f_norm
        pca_mean
        V
    end
    
    methods
        function obj = KalmanModel()
            %KALMANMODEL Construct an instance of this class
            obj.bw = 20;
            obj.delay = 50;
        end
        
        function [x_avg,y_avg,obj] = kinematics(obj,data)
            % KINEMATICS Calculates multiple kinematic variables
            % data - given struct array
            % x - x position extended to maximum length (assuming stationarity) 
            % y - y position extended to maximum length (assuming stationarity) 
            % x_avg - mean x position extended to maximum length (assuming stationarity) 
            % y_avg - mean y position extended to maximum length (assuming stationarity) 
            % x_vel - x velocity extended to maximum length (assuming stationarity) 
            % y_vel - y velocity extended to maximum length (assuming stationarity)
            % x_acc - x acceleration extended to maximum length (assuming stationarity)
            % y_acc - y acceleration extended to maximum length (assuming stationarity)  
            % l - time length (N) of each trial

            data_cell = struct2cell(data); % convert to cell matrix
            max_length = @(x) length(x); % function handle to get max length of all elements in cell
            l = cellfun(max_length,data_cell);
            l = squeeze(l(3,:,:)); % retain only handPos information

            L = max(l,[],'all');

            [T,A] = size(data); % get dimensions of data
            x_avg = zeros(A,L); % initialise variables
            y_avg = zeros(A,L);
            x = zeros(T,A,L);
            y = zeros(T,A,L);
            for a = 1:1:A
                for t = 1:1:T
                    var_x = data(t,a).handPos(1,:);
                    var_y = data(t,a).handPos(2,:);
                    x(t,a,:) = [var_x var_x(end)*ones(1,L-length(var_x))];
                    y(t,a,:) = [var_y var_y(end)*ones(1,L-length(var_y))];
                end
                x_avg(a,:) = squeeze(mean(x(:,a,:),1))';
                y_avg(a,:) = squeeze(mean(y(:,a,:),1))';
            end

        end

        function [X_A, Y_A, X_H, Y_H, obj] = extract_supervised(obj, training_data)
            % [X, Y] = EXTRACT_SUPERVISED(data) extracts data in the appropriate
            % format for supervised learning

            [T,A] = size(training_data); % get data size
            [obj.x_avg,obj.y_avg] = obj.kinematics(training_data);
            X_A(1:A) = {zeros(4, 1e5)}; % initialise variables
            Y_A(1:A) = {zeros(4, 1e5)};
            Y_H(1:A) = {zeros(98, 1e5)};
            obj.V = cell(1,8);
            obj.pca_mean = cell(1,8);
            
            for direc = 1:A
                samp_count = 0;
                for tr = 1:T
                    for t = max([obj.bw+obj.delay,21]):20:length(training_data(tr, direc).spikes)-20
                        samp_count = samp_count + 1;
                        X_A{direc}(1:2, samp_count) = training_data(tr, direc).handPos(1:2, t)...
                            - [obj.x_avg(direc, t); obj.y_avg(direc, t)];
                        X_A{direc}(3:4, samp_count) = (training_data(tr, direc).handPos(1:2, t)...
                            - training_data(tr, direc).handPos(1:2, t-20))/0.02;
                        Y_A{direc}(1:2, samp_count) = training_data(tr, direc).handPos(1:2, t+20)...
                             - [obj.x_avg(direc, t+20); obj.y_avg(direc, t+20)];
                        Y_A{direc}(3:4, samp_count) = (training_data(tr, direc).handPos(1:2, t+20)...
                            - training_data(tr, direc).handPos(1:2, t))/0.02;
                        Y_H{direc}(:, samp_count) = mean(training_data(tr, direc).spikes(:, t-obj.bw-obj.delay+1:t-obj.delay), 2);
                    end
                end
                % Adding bias to our hidden states and  remove extra zero elements
                X_A(direc) = {[X_A{direc}(:, 1:samp_count);ones(1,samp_count)]};
                
                X_H(direc) = {X_A{direc}(:, 1:samp_count)};
                Y_A(direc) = {[Y_A{direc}(:, 1:samp_count);ones(1,samp_count)]};
                
                % Normalizing frequency data (saving params for later normalization)
                obj.f_norm(direc).avg = mean(Y_H{direc}(:, 1:samp_count), 2);
                obj.f_norm(direc).stdev = std(Y_H{direc}(:, 1:samp_count), [], 2);
                Y_H(direc) = {(Y_H{direc}(:, 1:samp_count) - obj.f_norm(direc).avg)./obj.f_norm(direc).stdev};
                Y_dummy = Y_H{direc}; % dummy variable for editing
                Y_dummy(isnan(Y_dummy)) = 0; % no spiking
                Y_dummy(isinf(Y_dummy)) = 0; % no spiking
                Y_H(direc) = {Y_dummy};
                C = cov(Y_H{direc}');
                [V_eig,D] = eig(C);
                [~,I] = maxk(abs(diag(D)), 41);
                obj.V(direc) = {V_eig(:, I)};
                Y_H(direc) = {(Y_H{direc}'*obj.V{direc})'}; % Projection onto PCA subspace
                obj.pca_mean(direc) = {mean(Y_H{direc},2)};
                Y_H(direc) = {Y_H{direc} - obj.pca_mean{direc}};
                
            end
         
        end
   
        function obj = fit(obj,training_data)
            %FIT(training_data) learning the A and H matrices based on
            %training data using PCR
            
            [X_A, Y_A, X_H, Y_H, obj] = obj.extract_supervised(training_data);
            for a = 1:length(X_A) 
                % OLS solution for A
                obj.A{a} = Y_A{a}*X_A{a}'/(X_A{a}*X_A{a}');
                % OLS solution for H
                obj.H{a} = Y_H{a}*X_H{a}'/(X_H{a}*X_H{a}');
                % Estimating covariance matrices (Wu et. al, 2002 notation)
                obj.W{a} = (Y_A{a} - obj.A{a}*X_A{a})*(Y_A{a} - obj.A{a}*X_A{a})'/(length(Y_A{a}));
                obj.Q{a} = (Y_H{a} - obj.H{a}*X_H{a})*(Y_H{a} - obj.H{a}*X_H{a})'/(length(Y_H{a}));
            end
        end
        function [x, y, obj] = predict(obj, test_data, pred_angle)
            L = length(test_data.spikes);
            % Selecting past state value
            if length(test_data.spikes) <= 320
                obj.x_past = [test_data.startHandPos - ...
                    [obj.x_avg(pred_angle, 1); obj.y_avg(pred_angle, 1)]; 0; 0; 1]; % start at 0 velocity
                obj.P_past = zeros(size(obj.W{pred_angle}));
            end
            % Extracting observation information
            freqs = mean(test_data.spikes(:, end-obj.bw-obj.delay+1:end-obj.delay), 2);
            freqs = (freqs - obj.f_norm(pred_angle).avg)./(obj.f_norm(pred_angle).stdev);
            freqs(isnan(freqs)) = 0;
            freqs(isinf(freqs)) = 0;
            freqs = (freqs' * obj.V{pred_angle})';
            freqs = freqs - obj.pca_mean{pred_angle};
            % 1. Prediction Step
            x_priori = obj.A{pred_angle} * obj.x_past;
            P_priori = obj.A{pred_angle} * obj.P_past * obj.A{pred_angle}' + obj.W{pred_angle};
            % 2. Update Step
            K = P_priori*obj.H{pred_angle}'/(obj.H{pred_angle}*P_priori*obj.H{pred_angle}' + obj.Q{pred_angle}); % Kalman Gain
            x_current = x_priori + K*(freqs - obj.H{pred_angle}*x_priori);
            P_current = (eye(size(K, 1)) - K * obj.H{pred_angle})*P_priori;
            % Update appropriate quantities
            if L <= length(obj.x_avg)
                x = x_current(1) + obj.x_avg(pred_angle, L); 
                y = x_current(2) + obj.y_avg(pred_angle, L);
            else
                x = x_current(1) + obj.x_avg(pred_angle, end); 
                y = x_current(2) + obj.y_avg(pred_angle, end);
            end
            obj.P_past = P_current;
            obj.x_past = x_current;
        end
    end
end

