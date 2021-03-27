% RANDOM SEED PERFORMANCE ANALYSER

RMSE = zeros(1,100);
t = zeros(1,100);
f = waitbar(0,'Processing...');
for itr = 1:100
    [RMSE(itr),t(itr),modelParameters] = testFunction_for_students_MTb('kalman',true,false);
    waitbar(itr/100,f,'Processing...');
end
close(f);
beep;
