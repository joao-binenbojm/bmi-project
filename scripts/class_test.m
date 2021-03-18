%% Making optimal LDA for spider jumps
clc; clear variables; close all;
load monkeydata0;

accuracy = zeros(50,1);
Y = repmat([1:8]',50,1);
f = waitbar(0,'Processing...');
p_count = 0;
for i = 1:50
    ix = randperm(length(trial));
    trainingData = trial(ix(1:50),:);
    testData = trial(ix(51:end),:);
    mdl = ldaClassifier(3);
    mdl = mdl.fit(trainingData);
    Y_pred = zeros(50*8,1);
    counter = 0;
    for tr = 1:50
        for direc = 1:8
            counter = counter + 1;
            testData(tr,direc).spikes = testData(tr,direc).spikes(:,1:560);
            [out,mdl] = mdl.predict(testData(tr,direc));
            Y_pred(counter) = out;
        end
    end
    accuracy(i) = sum(Y_pred==Y)/length(Y);
    waitbar(i/50, f, 'Processing...');
end
beep;
close(f);