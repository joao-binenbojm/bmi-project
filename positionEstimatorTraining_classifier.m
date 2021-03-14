function  [modelParameters] = positionEstimatorTraining_classifier(trainingData)
    % - trainingData:
    %     trainingData(t,a)              (t = trial id,  k = reaching angle)
    %     trainingData(t,a).trialId      unique number of the trial
    %     trainingData(t,a).spikes(u,n)  (i = neuron id, t = time)
    %     trainingData(t,a).handPos(p,n) (d = dimension [1-3], t = time)
    
    [T,A] = size(trainingData); % get size of training data
    
    C_param = struct;
    R_param = struct;
    
    % Classification training
    
    class = Classifier(); % create Classifier class
    
    C = 5; % regularization
    s = 0.1; % variance
    
    C_param.LDA = class.LDA.fit(trainingData); % LDA classifier
    C_param.SVM = class.SVM.fit(trainingData,C,s); % SVM classifier
    C_param.NN = class.NN.fit(trainingData); % NN classifier
    
    % PCR regressor training
    
    dt = 20; % define time step
    N = 560; % define time limit
    range = 320:dt:N; % define relevant time steps
    
    [fr_total,~] = fr_features(trainingData,20,N);
    [x,y,x_avg,y_avg,x_vel,y_vel,x_acc,y_acc,~] = kinematics(trainingData); % calculate x and y positions padded to maximum length
    
    Trajectory.x_avg = x_avg; % store average trajectory as model parameter
    Trajectory.y_avg = y_avg;
    x_std = squeeze(std(x,1)); % calculate standard deviation from the mean trajectory across trials for all angles
    y_std = squeeze(std(y,1));
    
    x_detrended = zeros(T,A,size(x,3));
    y_detrended = zeros(T,A,size(x,3));
    for t = 1:T % Subtract position from mean position
        x_detrended(t,:,:) = squeeze(x(t,:,:))-x_avg;
        y_detrended(t,:,:) = squeeze(y(t,:,:))-y_avg;
    end
    
    x_detrended_sampled = x_detrended(:,:,range); % sample detrended data at relevant locations
    y_detrended_sampled = y_detrended(:,:,range);
    
    for a = 1:A
        for bin = 1:length(range)
            R_param(a,bin).x_avg_sampled = x_avg(a,range(bin)); % store mean positions at relevant locations
            R_param(a,bin).y_avg_sampled = y_avg(a,range(bin));
            R_param(a,bin).x_std_sampled = x_std(a,range(bin)); % store standard deviation of positions at relevant locations
            R_param(a,bin).y_std_sampled = y_std(a,range(bin));
            R_param(a,bin).x_vel_sampled = squeeze(mean(x_vel(:,a,range(bin)),1)); % store mean velocity at relevant locations
            R_param(a,bin).y_vel_sampled = squeeze(mean(y_vel(:,a,range(bin)),1));
            R_param(a,bin).x_acc_sampled = squeeze(mean(x_acc(:,a,range(bin)),1)); % store mean acceleration at relevant locations
            R_param(a,bin).y_acc_sampled = squeeze(mean(y_acc(:,a,range(bin)),1));
    
            idx_angle = (a-1)*T+1; % angle range index (for each a)
            bin_idx = (range(bin)/dt); % bin range index (for each bin)
            fr_bin = fr_total(idx_angle:idx_angle+T-1,1:98*bin_idx);
            bin_x = squeeze(x_detrended_sampled(:,a,bin));
            bin_y = squeeze(y_detrended_sampled(:,a,bin));
            bin_x_vel = squeeze(x_vel(:,a,bin)-squeeze(mean(x_vel(:,a,range(bin)),1))); % add detrended velocity
            bin_y_vel = squeeze(y_vel(:,a,bin)-squeeze(mean(y_vel(:,a,range(bin)),1)));
            bin_x_acc = squeeze(x_acc(:,a,bin)-squeeze(mean(x_acc(:,a,range(bin)),1))); % add detrended acceleration
            bin_y_acc = squeeze(y_acc(:,a,bin)-squeeze(mean(y_acc(:,a,range(bin)),1)));
            kin = [bin_x bin_y bin_x_vel bin_y_vel bin_x_acc bin_y_acc];
            
            fr_bin_avg = mean(fr_bin,1);
            R_param(a,bin).fr_bin_avg=fr_bin_avg; % store trial average firing rate per bin
            
            % Use PCA to extract principle components
            p = T-1;
            P = PCA(fr_bin,fr_bin_avg,p);
            W = P'*(fr_bin'-fr_bin_avg');
            update=P*(W*W')^(-1)*W*kin; % calculate linear regression
            R_param(a,bin).update = update;
        end
    end
    
    modelParameters.C_param = C_param;
    modelParameters.Trajectory = Trajectory;
    modelParameters.R_param = R_param;
    modelParameters.pred_angle = [];
    
end