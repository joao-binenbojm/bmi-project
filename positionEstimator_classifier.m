function [x, y, newModelParameters] = positionEstimator_classifier(testData, modelParameters)
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
        pred_angle_LDA = C_param.LDA.predict(testData); % classify angle from LDA 
%         pred_angle_SVM = C_param.SVM.predict(testData); % classify angle from SVM
%         pred_angle_NB = C_param.NB.predict(testData); % classify angle from NB
%         pred_angle_ECOC = C_param.ECOC.predict(testData); % classify angle from ECOC
    else
        pred_angle_LDA = modelParameters.pred_angle;
%         pred_angle_SVM = modelParameters.pred_angle;
%         pred_angle_NB = modelParameters.pred_angle;
%         pred_angle_ECOC = modelParameters.pred_angle;
    end 
    
%     if N == 320
%         pred_angle_NN = C_param.NN.predict(testData); % classify angle from NN
%     else 
%         pred_angle_NN = modelParameters.pred_angle;
%     end
    
    % majority voting
%     pred_angle = mode([pred_angle_NN pred_angle_LDA pred_angle_ECOC]);
    pred_angle = pred_angle_LDA;
%     pred_angle = modelParameters.real_angle;
    modelParameters.pred_angle = pred_angle;
    
    if N == 320
        modelParameters.percentage = modelParameters.percentage + (modelParameters.real_angle==pred_angle);
        modelParameters.counter = modelParameters.counter + 1;
    end
    
    % PCR regressor testing
    
    if N>560 % set N limit to 560
        N = 560;
    end
    dt = 20;
    range = [320:dt:560];
    
%     [fr_total,~] = fr_features(testData,dt,N); % preprocess EEG data
    param = modelParameters.R_param; % get PCR regressor model parameters
%     idx_bin = length(fr_total)/98-(320/dt-1);
      idx_bin = N/dt-(320/dt-1);
%     update_x = param(pred_angle,idx_bin).update(:,1);
%     update_y = param(pred_angle,idx_bin).update(:,2);
%     update_x_vel = param(pred_angle,idx_bin).update(:,3);
%     update_y_vel = param(pred_angle,idx_bin).update(:,4);
%     update_x_acc = param(pred_angle,idx_bin).update(:,5);
%     update_y_acc = param(pred_angle,idx_bin).update(:,6);
%     fr_bin_avg = param(pred_angle,idx_bin).fr_bin_avg;
    x_avg_sampled = param(pred_angle,idx_bin).x_avg_sampled;
    y_avg_sampled = param(pred_angle,idx_bin).y_avg_sampled;
%     x_vel_sampled = param(pred_angle,idx_bin).x_vel_sampled;
%     y_vel_sampled = param(pred_angle,idx_bin).y_vel_sampled;
%     x_acc_sampled = param(pred_angle,idx_bin).x_acc_sampled;
%     y_acc_sampled = param(pred_angle,idx_bin).y_acc_sampled;
    
%     x = (fr_total-fr_bin_avg)*update_x+x_avg_sampled;
%     y = (fr_total-fr_bin_avg)*update_y+y_avg_sampled;
% 
%     vx = (fr_total-fr_bin_avg)*update_x_vel+x_vel_sampled;
%     vy = (fr_total-fr_bin_avg)*update_y_vel+y_vel_sampled;
% 
%     acc_x = (fr_total-fr_bin_avg)*update_x_acc+x_acc_sampled;
%     acc_y = (fr_total-fr_bin_avg)*update_y_acc+y_acc_sampled;
      
%     x_prime = x_avg_sampled+vx;
%     y_prime = y_avg_sampled+vy;
%     vx_prime_2 = x_vel_sampled+acc_x;
%     vy_prime_2 = y_vel_sampled+acc_y;
%     x_prime_2 = x_avg_sampled+vx_prime_2;
%     y_prime_2 = y_avg_sampled+vy_prime_2;
    
%     x = (x+x_prime+x_prime_2)/3;
%     y = (y+y_prime+y_prime_2)/3;

%     x = x_prime_2;
%     y = y_prime_2;

%     x = x_prime;
%     y = y_prime;

    x = x_avg_sampled;
    y = y_avg_sampled;
    
    modelParameters.pred_pos = [x y];
    newModelParameters = modelParameters;
end
