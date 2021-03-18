% Finding mean rmse if fully training kalman model on data
clc; clear variables; close all;

rmse = zeros(50, length([3:50]));
f = waitbar(0,'Processing...');
p_count = 0;
for p=[3:50]
    for i = 1:50
        p_count = p_count + 1;
        [rmse(i,p),a,b] = testFunction_for_students_MTb('kalman', p);
        waitbar(p_count/(50*length([3:20])),f,'Processing...');
    end
end
beep;
close(f);