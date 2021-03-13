% finding optimal parameters
clc; clear variables; close all;
L = length([40:5:90])*length([30:10:100]);
rmse = zeros(1, L);
params = zeros(2, L);

p_count = 0;
for bw = [40:5:90]
    for delay = [30:10:100]
        p_count = p_count + 1;
        fprintf('Set %d/%d \n', p_count, L);
        rmse(1, p_count)= testFunction_for_students_MTb('brainiacs', bw, delay);
        params(:, p_count) = [bw; delay];
    end
end

