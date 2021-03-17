% finding mean rmse if fully training kalman model on data
clc; clear variables; close all;

rmse = zeros(50, 1);
for i = 1:50
    [rmse(i),a] = testFunction_for_students_MTb('kalman');
end