function [model] = positionEstimatorTraining(training_data)
  % Arguments:
  
  % - training_data:
  %     training_data(n,k)              (n = trial id,  k = reaching angle)
  %     training_data(n,k).trialId      unique number of the trial
  %     training_data(n,k).spikes(i,t)  (i = neuron id, t = time)
  %     training_data(n,k).handPos(d,t) (d = dimension [1-3], t = time)
  
  [T,~] = size(training_data); % get size of training data
    
  N = 560; % define end time
    
  [~,fr_avg] = fr_features(training_data,80,N); % obtaining firing rate feature space from training data
    
  % LDA classifier training
    
  Y=repmat([1:1:8]',T,1); % generate labels for classifier 
  model.C_param.Mdl_LDA = fitcdiscr(fr_avg,Y); % LDA classifier object
  
  % Kalman filter training
  
  A_npcr = 4;
  H_npcr = 4;
  model.K_param = KalmanModel();
  model.K_param = model.K_param.fit(training_data, A_npcr, H_npcr);
  
  % Return Value:
  
  % - model object:
  %     single model object that represents the trained model with
  %     appropriate model parameters
  
end