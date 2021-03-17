% finding optimal parameters
clc; clear variables; close all;
L = length([30:10:100]);
rmse = zeros(50, L);
params = zeros(2, L);
% length([20:5:90])
% Progress bar
f = waitbar(0, 'Processing...');
delays = [30:10:150];

p_count = 0;
bw = 20;
for delay = delays
    p_count = p_count + 1;
    timer_val = tic;
    fprintf('Set %d/%d \n', p_count, L);
    waitbar(p_count/L, f, 'Processing...');
    for i = 1:50
        rmse(i, p_count)= testFunction_for_students_MTb('kalman', bw, delay);
    end
     params(:, p_count) = delay;
end
beep;
close(f);
