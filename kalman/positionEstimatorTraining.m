function [model] = positionEstimatorTraining(trainingData)
    % Arguments:

    % - training_data:
    %     training_data(n,k)              (n = trial id,  k = reaching angle)
    %     training_data(n,k).trialId      unique number of the trial
    %     training_data(n,k).spikes(i,t)  (i = neuron id, t = time)
    %     training_data(n,k).handPos(d,t) (d = dimension [1-3], t = time)
  
    C_param = struct;

    % Classification training
    C_param.LDA1 =  ldaClassifier(1);
    model.C_param.LDA1 = C_param.LDA1.fit(trainingData);
    C_param.LDA2 = ldaClassifier(2);
    model.C_param.LDA2 = C_param.LDA2.fit(trainingData);
    C_param.LDA3 = ldaClassifier(3);
    model.C_param.LDA3 = C_param.LDA3.fit(trainingData);
    
    R_param = KalmanModel();
    model.R_param = R_param.fit(trainingData);
    model.pred_angle = [];
  
end