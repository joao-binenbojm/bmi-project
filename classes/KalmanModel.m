classdef KalmanModel
    %KALMANMODEL Model that accounts for learning matrices A and H
    
    properties
        A
        H
        Q
        W
        P_past
        x_past
        f_norm
    end
    
    methods
        function obj = KalmanModel()
            %KALMANMODEL Construct an instance of this class
        end
        
        function [X_A, Y_A, X_H, Y_H, obj] = extract_supervised(obj, training_data)
            % [X, Y] = EXTRACT_SUPERVISED(data) extracts data in the appropriate
            % format for supervised learning

            [T,A] = size(training_data); % get data size
            
            X_A = zeros(4, 15000); % initialise variables
            Y_A = zeros(4, 15000);
            Y_H = zeros(98, 15000);
            samp_count = 0;
            
            for tr = 1:T
                for direc = 1:A
                    for t = 170:20:length(training_data(tr, direc).spikes)
                        samp_count = samp_count + 1;
                        X_A(1:2, samp_count) = training_data(tr, direc).handPos(1:2, t-20);
                        X_A(3:4, samp_count) = (training_data(tr, direc).handPos(1:2, t-20)...
                            - training_data(tr, direc).handPos(1:2, t-40))/0.02;
                        Y_A(1:2, samp_count) = training_data(tr, direc).handPos(1:2, t);
                        Y_A(3:4, samp_count) = (training_data(tr, direc).handPos(1:2, t)...
                            - training_data(tr, direc).handPos(1:2, t-20))/0.02;
                        Y_H(:, samp_count) = mean(training_data(tr, direc).spikes(:, t-169:t-100), 2);
                    end     
                end
            end
            X_A = X_A(:, 1:samp_count); % remove extra zero elements
            X_H = X_A(:, 1:samp_count);
            Y_A = Y_A(:, 1:samp_count);
            % Normalizing frequency data (saving params for later normalization)
            obj.f_norm.avg = mean(Y_H(:, 1:samp_count), 2);
            obj.f_norm.stdev = std(Y_H(:, 1:samp_count), [], 2);
            Y_H = (Y_H(:, 1:samp_count) - obj.f_norm.avg)./obj.f_norm.stdev;
        end
        function obj = fit(obj,training_data, A_npcr, H_npcr)
            %FIT(training_data) learning the A and H matrices based on
            %training data using PCR
            
            [X_A, Y_A, X_H, Y_H, obj] = obj.extract_supervised(training_data);
            % PCR solution for A
            [U,S,V] = svds(X_A, A_npcr);
            obj.A = Y_A*(V/S)*U';
            % OLS solution for H
            [U,S,V] = svds(X_H, H_npcr);
            obj.H = Y_H*(V/S)*U';
            % Estimating covariance matrices (Wu et. al, 2002 notation)
            obj.W = (Y_A - obj.A*X_A)*(Y_A - obj.A*X_A)'/(length(Y_A));
            obj.Q = (Y_H - obj.H*X_H)*(Y_H - obj.H*X_H)'/(length(Y_H));
        end
        function [x, y, obj] = predict(obj, test_data)
            % Selecting past state value
            if length(test_data.spikes) <= 320
                obj.x_past = [test_data.startHandPos; 0; 0]; % star at 0 velocity
                obj.P_past = zeros(size(obj.W));
            end
            % Extracting observation information
            freqs = mean(test_data.spikes(:, end-169:end-100), 2);
            freqs = (freqs - obj.f_norm.avg)./(obj.f_norm.stdev);
            % 1. Prediction Step
            x_priori = obj.A * obj.x_past;
            P_priori = obj.A * obj.P_past * obj.A' + obj.W;
            % 2. Update Step
            K = P_priori*obj.H'/(obj.H*P_priori*obj.H' + obj.Q); % Kalman Gain
            x_current = x_priori + K*(freqs - obj.H*x_priori);
            P_current = (eye(size(K, 1)) - K * obj.H)*P_priori;
            % Update appropriate quantities
            x = x_current(1); y = x_current(2);
            obj.P_past = P_current;
            obj.x_past = x_current;
        end
    end
end

