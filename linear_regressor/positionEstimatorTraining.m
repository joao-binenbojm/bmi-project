function  [modelParameters] = positionEstimatorTraining(trainingData)
    % - trainingData:
    %     trainingData(t,a)              (t = trial id,  k = reaching angle)
    %     trainingData(t,a).trialId      unique number of the trial
    %     trainingData(t,a).spikes(u,n)  (i = neuron id, t = time)
    %     trainingData(t,a).handPos(p,n) (d = dimension [1-3], t = time)
    
    class = Classifier(); % create Classifier masterclass
    
    C_param.LDA = class.LDA.fit(trainingData);
%     C_param.SVM = class.SVM.fit(trainingData,5,0.05);
%     C_param.ECOC = class.ECOC.fit(trainingData);
%     C_param.NB = class.NB.fit(trainingData);
%     C_param.NN = class.NN.fit(trainingData);
    
    % PCR linear regressor training
    
    lin = Lin_regressor;
    
    R_param = lin.fit(trainingData);
    
    modelParameters.C_param = C_param;
    modelParameters.R_param = R_param;
    modelParameters.pred_angle = [];
    
end