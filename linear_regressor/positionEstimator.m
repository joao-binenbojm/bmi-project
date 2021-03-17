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
    
    % Classification testing
    
    N = length(testData.spikes); % get trial length
    
%     if N==320 || N==400 || N==480 || N==560
%         pred_angle = modelParameters.C_param.LDA.predict(testData); % classify angle from LDA 
%         pred_angle = modelParameters.C_param.SVM.predict(testData); % classify angle from SVM
%         pred_angle = modelParameters.C_param.ECOC.predict(testData); % classify angle from ECOC
%         pred_angle = modelParameters.C_param.NB.predict(testData); % classify angle from NB
%         modelParameters.pred_angle = pred_angle;
%     else
%         pred_angle = modelParameters.pred_angle;
%     end

%     if N==320
%         pred_angle = modelParameters.C_param.NN.predict(testData); % classify angle from NN
%         modelParameters.pred_angle = pred_angle;
%     else
%         pred_angle = modelParameters.pred_angle;
%     end
    pred_angle = modelParameters.real_angle;
    if N==560
        modelParameters.percentage = modelParameters.percentage+double(pred_angle==modelParameters.real_angle);
        modelParameters.count = modelParameters.count+1;
    end
    % PCR regressor testing
    
    [x,y] = modelParameters.R_param.predict(testData,pred_angle,'avg');
    
    modelParameters.pred_pos = [x y];
    newModelParameters = modelParameters;
end

