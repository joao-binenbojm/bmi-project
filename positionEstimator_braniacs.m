function [x, y, newModelParameters] = positionEstimator_braniacs(testData, modelParameters)
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
    
    % Classification testing
    
    N = length(testData.spikes); % get trial length
    
    if N==320 || N==400 || N==480 || N==560
        C_param = modelParameters.C_param; % extract LDA classification parameters
        [~,fr_avg] = fr_features(testData,80,N); % preprocess EEG data
        if N==320 % clear list for next trial
            modelParameters.pred_angle = [];
        end
        pred_angle = predict(C_param.Mdl_LDA,fr_avg); % classify angle from LDA
        prev_pred_angle = modelParameters.pred_angle; % append new pred_angle to parameters
        modelParameters.pred_angle = [prev_pred_angle pred_angle];
            
    end
    
    pred_angle_list = modelParameters.pred_angle; 
    [pred_angle,~,C] = mode(pred_angle_list); % majority voting
    
    if length(cell2mat(C))~=1 % rely more on last predicted angle (based on more data)
        pred_angle = pred_angle_list(end);
    end
    
    % PCR regressor testing
    
    if N>560 % set N limit to 560
        N = 560;
    end
    dt = 20;
    range = [320:dt:560];
    
    [fr_total,~] = fr_features(testData,dt,N); % preprocess EEG data
    param = modelParameters.R_param; % get PCR regressor model parameters
    idx_bin = length(fr_total)/98-(320/dt-1);
    update_x = param(pred_angle,idx_bin).update(:,1);
    update_y = param(pred_angle,idx_bin).update(:,2);
    fr_bin_avg = param(pred_angle,idx_bin).fr_bin_avg;
    x_avg_sampled = param(pred_angle,idx_bin).x_avg_sampled;
    y_avg_sampled = param(pred_angle,idx_bin).y_avg_sampled;
    
    x = (fr_total-fr_bin_avg)*update_x+x_avg_sampled;
    y = (fr_total-fr_bin_avg)*update_y+y_avg_sampled;
    
    newModelParameters = modelParameters;
end

