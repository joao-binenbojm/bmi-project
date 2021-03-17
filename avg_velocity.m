% Testing to see whether there is an improvement by including averaged
% velocity deviations instead of predicting just velocity
clc; clear variables; close all;

rmse = zeros(50, 1);
for i = 1:50
    [rmse(i),a] = testFunction_for_students_MTb('kalman');
end