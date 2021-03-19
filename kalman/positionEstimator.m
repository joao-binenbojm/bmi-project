function [x, y, model] = positionEstimator(testData, model)
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
  
    N = length(testData.spikes); % get trial length

    % Classification testing
    C_param = model.C_param; % extract classification parameters

    if N==320
        pred_angle = C_param.LDA1.predict(testData); % classify angle from LDA 
    elseif N==440
        pred_angle = C_param.LDA2.predict(testData);
    elseif N==560
        pred_angle = C_param.LDA3.predict(testData);
    else
        pred_angle = model.pred_angle;
    end 

    model.pred_angle = pred_angle;
    
    [x, y, model.R_param] = model.R_param.predict(testData, pred_angle);
   
end

