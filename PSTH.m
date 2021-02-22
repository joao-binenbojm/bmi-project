function [] = PSTH(data,sel,period)
    % [] = PSTH(data,sel,period)
    % data - given struct array
    % sel - struct with fields:
        %.angle - single angle value
        %.unit - single unit value
    % period - time interval, must be multiple
    % of the number of samples per trial
        
    data_length = data(sel.trial,sel.angle).spikes;    
    N = length(data_length);
    [T,~] = size(data);
    
    edges = 0:period:N;
    psth = zeros(length(edges)-1,1);
    
    for jj = 1:1:T
        var = data(jj,sel.angle).spikes(sel.unit,:);
        N = length(var);
        var(data(jj,sel.angle).spikes(sel.unit,:)==0) = NaN;
        psth = psth + histcounts([1:1:N].*var,edges)';
    end
    figure;
    bar(period:period:length(psth)*period,psth','b');
    set(gca,'FontSize',15);
    xlabel('Time [ms]','FontSize',20);
    ylabel('\# of spikes','FontSize',20);    
end
