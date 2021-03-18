function [x, y, newModelParameters] = positionEstimator(testData, modelParameters)
    % - test_data:
    % test_data(m).trialID
    % unique trial ID
    % test_data(m).startHandPos
    % 2x1 vector giving the [x y] position of the hand at the start
    % of the trial
    % test_data(m).decodedHandPos
    % [2xN] vector giving the hand position estimated by your
    % algorithm during the previous iterations. In this case, N is
    % the number of times your function has been called previously on
    % the same data sequence.
    % test_data(m).spikes(i,t) (m = trial id, i = neuron id, t = time)
    % in this case, t goes from 1 to the current time in steps of 20
    
    N = length(testData.spikes); % get trial length
    
    % Classification testing
    C_param = modelParameters.C_param; % extract classification parameters
    
    if N==320 || N==400 || N==480 || N==560
%         pred_angle_LDA = C_param.LDA.predict(testData); % classify angle from LDA 
%         pred_angle_SVM = C_param.SVM.predict(testData); % classify angle from SVM
        pred_angle_NB = C_param.NB.predict(testData); % classify angle from NB
%         pred_angle_ECOC = C_param.ECOC.predict(testData); % classify angle from ECOC
    else
%         pred_angle_LDA = modelParameters.pred_angle;
%         pred_angle_SVM = modelParameters.pred_angle;
        pred_angle_NB = modelParameters.pred_angle;
%         pred_angle_ECOC = modelParameters.pred_angle;
    end 
    
%     if N == 320
%         pred_angle_NN = C_param.NN.predict(testData); % classify angle from NN
%     else 
%         pred_angle_NN = modelParameters.pred_angle;
%     end
    
    % majority voting
%     pred_angle = mode([pred_angle_NN pred_angle_LDA pred_angle_ECOC]);
    pred_angle = pred_angle_NB;
    modelParameters.pred_angle = pred_angle;
    
    if N == 320
        modelParameters.percentage = modelParameters.percentage + (modelParameters.real_angle==pred_angle);
        modelParameters.count = modelParameters.count + 1;
    end
    
    % PCR regressor testing
    
    if N>560 % set N limit to 560
        N = 560;
    end

    param = modelParameters.R_param; % get PCR regressor model parameters
    idx_bin = N/20-(320/20-1);
    x = param.x_avg_sampled(pred_angle,idx_bin);
    y = param.y_avg_sampled(pred_angle,idx_bin);
    
    modelParameters.pred_pos = [x y];
    newModelParameters = modelParameters;
end

