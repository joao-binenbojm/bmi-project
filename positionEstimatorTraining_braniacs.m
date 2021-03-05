function  [modelParameters] = positionEstimatorTraining_braniacs(trainingData)
    % - trainingData:
    %     trainingData(t,a)              (t = trial id,  k = reaching angle)
    %     trainingData(t,a).trialId      unique number of the trial
    %     trainingData(t,a).spikes(u,n)  (i = neuron id, t = time)
    %     trainingData(t,a).handPos(p,n) (d = dimension [1-3], t = time)
    
    [T,A] = size(trainingData); % get size of training data
    
    C_param = struct;
    R_param = struct;
    N = 560; % define end time
    
    [~,fr_avg] = fr_features(trainingData,80,N); % obtaining firing rate feature space from training data
    
    % LDA classifier training
    
    Y=repmat([1:1:8]',T,1); % generate labels for classifier 
    C_param.Mdl_LDA = fitcdiscr(fr_avg,Y); % LDA classifier object
    C_param.Mdl_tree = fitctree(fr_avg,Y,'AlgorithmForCategorical','Exact'); % Tree classifier object
    C_param.Mdl_knn = fitcknn(fr_avg,Y); % KNN classifier object
    
    % PCR regressor training
    
    dt = 20; % define time step
    range = 320:dt:N; % define relevant time steps
    
    [fr_total,~] = fr_features(trainingData,20,N);
    [x,y,x_avg,y_avg,~,~,~,~,~] = kinematics(trainingData); % calculate x and y positions padded to maximum length
    
    Trajectory.x = x_avg; % store average trajectory as model parameter
    Trajectory.y = y_avg;
    
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
    
            idx_angle = (a-1)*T+1; % angle range index (for each a)
            bin_idx = (range(bin)/dt); % bin range index (for each bin)
            fr_bin = fr_total(idx_angle:idx_angle+T-1,1:98*bin_idx);
            bin_x = squeeze(x_detrended_sampled(:,a,bin));
            bin_y = squeeze(y_detrended_sampled(:,a,bin));
            
            fr_bin_avg = mean(fr_bin,1);
            
            % Use PCA to extract principle components
            p = T-1;
            P = PCA(fr_bin,fr_bin_avg,p);
            W = P'*(fr_bin'-fr_bin_avg');
            R_param(a,bin).fr_bin_avg=fr_bin_avg;
            dx=P*(W*W')^(-1)*W* bin_x; % calculate linear regression
            dy=P*(W*W')^(-1)*W* bin_y;
            R_param(a,bin).update = [dx,dy];
        end
    end
    
    modelParameters.C_param = C_param;
    modelParameters.Trajectory = Trajectory;
    modelParameters.R_param = R_param;
    modelParameters.pred_angle = [];
    
end