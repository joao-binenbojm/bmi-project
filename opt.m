% finding optimal parameters
clc; clear variables; close all;
L = length([20:5:90])*length([30:10:100]);
rmse = zeros(50, L);
params = zeros(2, L);

% Progress bar
f = waitbar(0, 'Processing...');

p_count = 0;
for bw = [20:5:90]
    for delay = [30:10:150]
        p_count = p_count + 1;
        timer_val = tic;
%         fprintf('Set %d/%d \n', p_count, L);
        waitbar(p_count/L, f, 'Processing...');
        for i = 1:50
            rmse(i, p_count)= testFunction_for_students_MTb('kalman', bw, delay);
        end
         params(:, p_count) = [bw; delay];
    end
end
beep;
close(f);
