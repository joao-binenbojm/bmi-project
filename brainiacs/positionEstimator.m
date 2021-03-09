function [x, y, model] = positionEstimator(test_data, model)

  % **********************************************************
  %
  % You can also use the following function header to keep your state
  % from the last iteration
  %
  % function [x, y, newModelParameters] = positionEstimator(test_data, modelParameters)
  %                 ^^^^^^^^^^^^^^^^^^
  % Please note that this is optional. You can still use the old function
  % declaration without returning new model parameters. 
  %
  % *********************************************************
  

  % - test_data:
  %     test_data(m).trialID
  %         unique trial ID
  %     test_data(m).startHandPos
  %         2x1 vector giving the [x y] position of the hand at the start
  %         of the trial
  %     test_data(m).decodedHandPos
  %         [2xN] vector giving the hand position estimated by your
  %         algorithm during the previous iterations. In this case, N is 
  %         the number of times your function has been called previously on
  %         the same data sequence.
  %     test_data(m).spikes(i,t) (m = trial id, i = neuron id, t = time)
  %     in this case, t goes from 1 to the current time in steps of 20
  %     Example:
  %         Iteration 1 (t = 320):
  %             test_data.trialID = 1;
  %             test_data.startHandPos = [0; 0]
  %             test_data.decodedHandPos = []
  %             test_data.spikes = 98x320 matrix of spiking activity
  %         Iteration 2 (t = 340):
  %             test_data.trialID = 1;
  %             test_data.startHandPos = [0; 0]
  %             test_data.decodedHandPos = [2.3; 1.5]
  %             test_data.spikes = 98x340 matrix of spiking activity
  
  
  
  % ... compute position at the given timestep.
  
  % Return Value:
  % - [x, y]:
  %     current position of the hand
  
  % Classification testing
    
  N = length(test_data.spikes); % get trial length
    
  if N==320 || N==400 || N==480 || N==560
      C_param = model.C_param; % extract LDA classification parameters
      [~,fr_avg] = fr_features(test_data,80,N); % preprocess EEG data
      pred_angle = predict(C_param.Mdl_LDA,fr_avg); % classify angle from LDA 
      model.C_param.pred_angle = pred_angle;
  else
      pred_angle = model.C_param.pred_angle;
  end
  
  % Kalman filter testing
  
  [x, y, model.K_param] = model.K_param.predict(test_data,pred_angle);
   
end

