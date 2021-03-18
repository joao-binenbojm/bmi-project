function  [modelParameters] = positionEstimatorTraining(trainingData)
    % - trainingData:
    %     trainingData(t,a)              (t = trial id,  k = reaching angle)
    %     trainingData(t,a).trialId      unique number of the trial
    %     trainingData(t,a).spikes(u,n)  (i = neuron id, t = time)
    %     trainingData(t,a).handPos(p,n) (d = dimension [1-3], t = time)
    
    [T,A] = size(trainingData); % get size of training data
    
    C_param = struct;
    R_param = struct;
    
    % Classification training
    C_param.LDA1 =  ldaClassifier(1);
    C_param.LDA1 = C_param.LDA1.fit(trainingData);
    C_param.LDA2 = ldaClassifier(2);
    C_param.LDA2 = C_param.LDA2.fit(trainingData);
    C_param.LDA3 = ldaClassifier(3);
    C_param.LDA3 = C_param.LDA3.fit(trainingData);
    
    % PCR regressor training
    [x_avg,y_avg] = kinematics(trainingData);
    
    R_param.x_avg_sampled = x_avg(:,320:20:560);
    R_param.y_avg_sampled = y_avg(:,320:20:560);
    
    modelParameters.C_param = C_param;
    modelParameters.R_param = R_param;
    modelParameters.pred_angle = [];
    
end