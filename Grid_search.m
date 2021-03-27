% RANDOM SEED PARAMETRIC GRID SEARCH

BW = 20:10:100;
LAG = 0:10:100;
RMSE = zeros(length(BW),length(LAG),100);
f = waitbar(0,'Processing...');
for bw = 1:length(BW)
    for lag = 1:length(LAG)
        param.bw = BW(bw);
        param.lag = LAG(lag);
        for itr = 1:1:100
            [RMSE(bw,lag,itr),~,modelParameters] = testFunction_for_students_MTb('kalman',true,false,param);
        end
        waitbar(bw/length(BW),f,'Processing...');
    end
end
close(f);
beep;