classdef PCRRegression
    properties
        data
        W
        lda_classifier
        ntrials
        theta
    end
    methods
        % Constructor
        function obj = PCRRegression(data)
            obj.data = data;
            obj.ntrials = length(data);
        end
        % Frequency estimator
        function F = freq_est(obj, spikes)
            F = mean(spikes, 2);
            F = squeeze(F);
        end
        % LDA classifier
        function obj = lda_train(obj, lda_data)
            train_label = repmat([1:8], 1, obj.ntrials);
            obj.lda_classifier = fitcdiscr(lda_data', train_label');
        end
        % Calling the model
        function pred = predict(obj, X)
            pred = obj.W * X; % adding 1s for bias
        end
        % Takes in data and extracts data in format supervised models like
        function [X, Y, lda, n_samples] = extract_supervised(obj)
            n_trials = length(obj.data);
            X = []; Y = []; 
            lda = []; n_samples = zeros(n_trials*8, 1); % number of predictions per trial
            trial_counter = 0;
            for T = 1:n_trials
                for A = 1:8
                    lda = [lda, mean(obj.data(T, A).spikes(:, 1:320), 2)];
                    samp_count = 0;
                    for t = 320:20:length(obj.data(T, A).spikes)
                        if t == 320
                            Y = [Y, obj.data(T, A).handPos(1:2, 320)...
                                - obj.data(T, A).handPos(1:2, 1)];
                        else
                            Y = [Y, obj.data(T, A).handPos(1:2, t)...
                                 - obj.data(T, A).handPos(1:2, t-19)];
                        end
                        X = [X, mean(obj.data(T, A).spikes(:, 300:t), 2)];
                        samp_count = samp_count + 1;
                    end
                    trial_counter = trial_counter + 1;
                    n_samples(trial_counter) = samp_count;
                end
            end
        end
        % Fitting the model to the data
        function obj = fit(obj, n_pcr)
            % Extracting data for supervised learning 
            [X,Y,lda_data,n_samples] = obj.extract_supervised();
            obj = obj.lda_train(lda_data);
            class_labels = predict(obj.lda_classifier, lda_data');
            angles = [];
            for T = 1:obj.ntrials*8
                for n = 1:n_samples(T) % as many of the same angle as n_samples
                    angles = [angles, class_labels(T)];
                end
            end
            % Number of trials for training
            X = [X; angles; ones(1, length(X))];
            [U,S,V] = svds(X, n_pcr);
            obj.W = Y*(V*inv(S)*U');
        end
         % Predictor function given current spikes and model weights
        function [x, y, obj] = pos_estimator(obj, test_data)
            if length(test_data.spikes) <= 320
                current_pos = test_data.startHandPos;
                spike_count = mean(test_data.spikes(:, 1:320), 2);
                obj.theta = predict(obj.lda_classifier, spike_count');
            else
                current_pos = test_data.decodedHandPos(:, end);
            end
            F = obj.freq_est(test_data.spikes(:, 300:end));
            X = [F; obj.theta; 1]; % design matrix
            decoded_pos = current_pos + obj.predict(X);
            x = decoded_pos(1); y = decoded_pos(2);
        end
    end
end