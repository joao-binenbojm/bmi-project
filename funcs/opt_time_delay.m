function [error,opt_lag] = opt_time_delay(data,dt,N,lag)
    %OPT_TIME_DELAY Calculates optimal lag between neural data
    %and hand position for each neural unit for all angles
    % data - given struct array
    % dt - bin size
    % N - data length limit
    % lag - vector indicating causal lags
    % error - tensor containing MSE error for all units and angles for each
    % lag
    % opt_lag - struct array with optimal lag for each unit and angle
    
    lag = lag/dt;
    
    [T,A] = size(data); % get trial and angle size
    
    [fr_total,~] = fr_features(data,dt,N); % extract features from spikes data
    fr_total = fr_total*dt; % turn into spike count
    [~,~,~,~,x_vel,y_vel,~,~,~] = kinematics(data); % extract kinematics from handPos data
    
    error = zeros(98,A,length(lag));
    for l = 1:length(lag)
        frFit = zeros(T,98,N/dt-lag(l));
        PSTH_est = zeros(98,N/dt-lag(l),A);
        PSTH_emp = zeros(98,N/dt-lag(l),A);
        for a = 1:1:A
            sel.angle = a;
            for t = 1:1:T
                kin.x_vel = squeeze(x_vel(t,a,1:dt:N));
                kin.y_vel = squeeze(y_vel(t,a,1:dt:N));
                for u = 1:1:98
                    sel.unit = u;
                    fr = fr_total(a:8:end,u:98:end);
                    PSTH_emp(u,:,a) = sum(fr(:,1:end-lag(l)),1);
                    fr = fr(t,1:end-lag(l))';
                    numBins = size(fr,1);
                    predictor = [ones(numBins,1) kin.x_vel(lag(l)+1:end) kin.y_vel(lag(l)+1:end)];
                    coeff = glmfit(predictor(:,2:end),fr,'poisson');
                    frFit(t,u,:) = exp(predictor*coeff); 
                end
            end
            PSTH_est(:,:,a) = squeeze(sum(frFit,1));
        end
        error(:,:,l) = squeeze(mean(((PSTH_est-PSTH_emp).^2),2));
    end
    
    [~,opt_lag] = min(error,[],3);
    opt_lag = (opt_lag-1)*dt;
end

