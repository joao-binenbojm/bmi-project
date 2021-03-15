function [x, y,newModelParameters] = positionEstimator(testData, modelParameters)

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
  
  N = length(testData.spikes); % get trial length
    
    % Classification testing
    C_param = modelParameters.C_param; % extract classification parameters
    
%     if N==320 || N==400 || N==480 || N==560
%         pred_angle_LDA = C_param.LDA.predict(testData); % classify angle from LDA 
%         pred_angle_SVM = C_param.SVM.predict(testData); % classify angle from SVM
%         pred_angle_NB = C_param.NB.predict(testData); % classify angle from NB
%         pred_angle_ECOC = C_param.ECOC.predict(testData); % classify angle from ECOC
%     else
%         pred_angle_LDA = modelParameters.pred_angle;
%         pred_angle_SVM = modelParameters.pred_angle;
%         pred_angle_NB = modelParameters.pred_angle;
%         pred_angle_ECOC = modelParameters.pred_angle;
%     end 
    
    if N==320
        pred_angle_NN = C_param.NN.predict(testData); % classify angle from NN
    end
    
    % majority voting
%     pred_angle = mode([pred_angle_NN pred_angle_LDA pred_angle_ECOC]);
    pred_angle = pred_angle_NN;
    modelParameters.pred_angle = pred_angle;
    
    % Kalman model testing
    R_param = modelParameters.R_param;
    [x, y, R_param.model] = R_param.model.predict(testData, pred_angle);
    
    modelParameters.pred_pos = [x y];
    newModelParameters = modelParameters;
   
end

