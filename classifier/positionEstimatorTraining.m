function  [modelParameters] = positionEstimatorTraining(trainingData)
    % - trainingData:
    %     trainingData(t,a)              (t = trial id,  k = reaching angle)
    %     trainingData(t,a).trialId      unique number of the trial
    %     trainingData(t,a).spikes(u,n)  (i = neuron id, t = time)
    %     trainingData(t,a).handPos(p,n) (d = dimension [1-3], t = time)
    
    C_param = struct;
    R_param = struct;
    
    % Classification training
    
    class = Classifier(); % create Classifier class
    
    C_param.LDA = class.LDA.fit(trainingData); % LDA classifier
%     C_param.SVM = class.SVM.fit(trainingData,5,0.05); % SVM classifier
%     C_param.NN = class.NN.fit(trainingData); % NN classifier
%     C_param.NB = class.NB.fit(trainingData); % NB classifier
%     C_param.ECOC = class.ECOC.fit(trainingData); % ECOC classifier
    
    % PCR regressor training
    
    range = 320:20:560; % define relevant time steps
    
    [~,~,x_avg,y_avg,~,~,~,~,~] = kinematics(trainingData); % calculate x and y positions padded to maximum length
    
    R_param.x_avg_sampled = x_avg(:,range); % store mean positions at relevant locations
    R_param.y_avg_sampled = y_avg(:,range);
    
    modelParameters.C_param = C_param;
    modelParameters.R_param = R_param;
    modelParameters.pred_angle = [];
    
end