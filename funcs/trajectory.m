function [x_avg,y_avg] = trajectory(data)
    % KINEMATICS Calculates multiple kinematic variables
    % data - given struct array
    % x - x position extended to maximum length (assuming stationarity) 
    % y - y position extended to maximum length (assuming stationarity) 
    % x_avg - mean x position extended to maximum length (assuming stationarity) 
    % y_avg - mean y position extended to maximum length (assuming stationarity) 
    % x_vel - x velocity extended to maximum length (assuming stationarity) 
    % y_vel - y velocity extended to maximum length (assuming stationarity)
    % x_acc - x acceleration extended to maximum length (assuming stationarity)
    % y_acc - y acceleration extended to maximum length (assuming stationarity)  
    % l - time length (N) of each trial
    
    data_cell = struct2cell(data); % convert to cell matrix
    max_length = @(x) length(x); % function handle to get max length of all elements in cell
    l = cellfun(max_length,data_cell);
    L = max(squeeze(l(3,:,:)),[],'all'); % retain only handPos information
    
    [T,A] = size(data); % get dimensions of data
    x_avg = zeros(A,L); % initialise variables
    y_avg = zeros(A,L);
    x = zeros(T,A,L);
    y = zeros(T,A,L);
    for a = 1:1:A
        for t = 1:1:T
            var_x = data(t,a).handPos(1,:);
            var_y = data(t,a).handPos(2,:);
            x(t,a,:) = [var_x var_x(end)*ones(1,L-length(var_x))];
            y(t,a,:) = [var_y var_y(end)*ones(1,L-length(var_y))];
        end
        x_avg(a,:) = squeeze(mean(x(:,a,:),1))';
        y_avg(a,:) = squeeze(mean(y(:,a,:),1))';
    end
    
end

