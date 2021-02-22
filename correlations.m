%% Correlation Exploration Nation %%
clc; clear all; close all;
load monkeydata_training

% Testing out cross-correlation matrix heatmap
sel.fs = 1000; lag_range = 0.5; % seconds
sel.trial = [1:100]; sel.angle = 1; sel.unit = 20; 
sel.range = [-lag_range*sel.fs:lag_range*sel.fs];
figure(1);
map = xcorrmap(trial, sel, true);

%Computing heatmap for all angles
figure(2); 
for i = 1:8
    sel.angle = i;
    subplot(2, 4, i);
    map = xcorrmap(trial, sel, true);
end
