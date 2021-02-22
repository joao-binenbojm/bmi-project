function peak = tuning_curve(data,unit,dt,opt)
    % peak = TUNING_CURVE(data,unit,dt,opt)
    % data - given struct array 
    % unit - scalar determining unit
    % dt - scalar determining time interval in ms
    % opt - string argument: 
        % 'count' - fire rate as spike count
        % 'density' - fire rate as spike density
    % peak = scalar determining preferred angle
        
    [T,A] = size(data);
    angle_list = [30/180*pi,70/180*pi,110/180*pi,150/180*pi,190/180*pi,230/180*pi,310/180*pi,350/180*pi];
   
    % Rate as spike count
    
    if strcmpi(opt,'count')
        for j = 1:1:A
            for i = 1:1:T
                n = length(data(i,j).spikes(unit,:));
                counts = sum(data(i,j).spikes(unit,:));
                rate = counts/n;
                total(i) = rate;
            end
            fr(j) = mean(total);
            fr_std(j) = std(total);
        end
        
    elseif strcmpi(opt,'density')
    
        % Rate as spike density

        for j = 1:1:A
            for i = 1:1:T
                n = length(data(i,j).spikes(unit,:));
                counts = histcounts([1:1:n].*data(i,j).spikes(unit,:),0:dt:n);
                  rate = counts/(dt);
                time_avg(i) = mean(rate);
            end
            fr(j) = mean(time_avg);
            fr_std(j) = std(time_avg);
        end
    end
    
    [~,peak] = max(fr);
    
    figure;
    errorbar(angle_list,fr,fr_std,'-s','LineWidth',2,'Color','k','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red');
    set(gca,'FontSize',15);
    xlabel('Angle [rad]','FontSize',20);
    ylabel('Firing rate [spikes/s]','FontSize',20);

    
end

