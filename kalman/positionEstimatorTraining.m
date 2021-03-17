function [modelParameters] = positionEstimatorTraining(trainingData, bw, delay)
    % Arguments:

    % - training_data:
    %     training_data(n,k)              (n = trial id,  k = reaching angle)
    %     training_data(n,k).trialId      unique number of the trial
    %     training_data(n,k).spikes(i,t)  (i = neuron id, t = time)
    %     training_data(n,k).handPos(d,t) (d = dimension [1-3], t = time)
 
    [T,A] = size(trainingData); % get size of training data
     
    C_param = struct;
    R_param = struct;
    
    % Classification training
    
    class = Classifier(); % create Classifier class
    
    C = 5; % regularization
    s = 0.05; % variance
    
%     C_param.LDA = class.LDA.fit(trainingData); % LDA classifier
%     C_param.SVM = class.SVM.fit(trainingData,C,s); % SVM classifier
%     C_param.NN = class.NN.fit(trainingData); % NN classifier
%     C_param.NB = class.NB.fit(trainingData); % NB classifier
%     C_param.ECOC = class.ECOC.fit(trainingData); % ECOC classifier
    
    R_param.model = KalmanModel(bw, delay);
    R_param.model = R_param.model.fit(trainingData);
 
%     modelParameters.C_param = C_param;
    modelParameters.R_param = R_param;
    modelParameters.pred_angle = [];
  
end