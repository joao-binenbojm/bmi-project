function [fr_total, fr_avg] = fr_features(data,dt,N)
    %FR_FEATURES Calculates the firing rate of the data in bins of size dt.
    % data - given data struct
    % dt - time bin size
    % N - total number of samples length of
    % fr_total - spiking rate divided in bins
    % fr_avg - average spiking rate across bins
    
    [T,A] = size(data); %get trial and angle length
    
    acc = 1;
    fr_avg = zeros(T*A,98);
    fr_total = zeros(T*A,N/dt*98);
    for t=1:1:T
        for a=1:1:A
            fr = zeros(98,length(0:dt:N)-1);
            for u=1:1:98
                var = data(t,a).spikes(u,1:N);
                var(var==0) = NaN;
                count = histcounts([1:1:N].*var,0:dt:N);
                fr(u,:) = count/dt;
            end
            fr_avg(acc,:) = mean(fr,2);
            f = reshape(fr,size(fr,1)*size(fr,2),1);
            fr_total(acc,:) = f;
            acc = acc+1;
        end
    end
end

