function peak = tuning_curve(data,unit,dt,opt,show)
    % peak = TUNING_CURVE(data,unit,dt,opt,show)
    % data - given struct array 
    % unit - scalar determining unit
    % dt - scalar determining time interval in ms
    % opt - string argument: 
        % 'count' - fire rate as spike count
        % 'density' - fire rate as spike density
    % show - string argument: 
        % 'show' - plots graph
    % peak = scalar determining preferred angle
        
    [T,A] = size(data);
    angle_list = [30/180*pi,70/180*pi,110/180*pi,150/180*pi,190/180*pi,230/180*pi,310/180*pi,350/180*pi];
    
%     N_array = zeros(1,T);
%     for i = 1:1:T
%         for j = 1:1:A
%             plot_data = data(i,j).spikes(unit,:);
%             N_array(i) = length(plot_data);
%         end
%     end
%     N = max(N_array);
%     max_edges = 0:dt:N;
    
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
                var = data(i,j).spikes(unit,:);
                var(var==0) = NaN;
                counts = histcounts([1:1:n].*var,0:dt:n);
                  rate = counts/(dt);
                time_avg(i) = mean(rate);
            end
            fr(j) = mean(time_avg);
            fr_std(j) = std(time_avg);
        end
        
        
%         % Rate as spike density
%         
%         counts = zeros(T,length(max_edges));
%         for j = 1:1:A
%             for i = 1:1:T
%                 n = length(data(i,j).spikes(unit,:));
%                 edges = 0:dt:n;
%                 var = data(i,j).spikes(unit,:);
%                 var(var==0) = NaN;
%                 counts(i,1:1:length(edges)-1) = histcounts([1:1:n].*var,edges);
%             end
%             trial_avg = sum(counts,1)/length(counts);
%             fr(j) = mean(trial_avg);
%             fr_std(j) = std(trial_avg);
%         end
        
    end
    
    [~,peak] = max(fr);
    
    if strcmpi(show,'show')
        errorbar(angle_list,fr,fr_std,'-s','LineWidth',2,'Color','k','MarkerSize',10,...
        'MarkerEdgeColor','red','MarkerFaceColor','red');
        set(gca,'FontSize',15);
        xlabel('Angle [rad]','FontSize',20);
        ylabel('Firing rate [spikes/s]','FontSize',20);
    end
end

