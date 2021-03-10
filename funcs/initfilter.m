function data_out = initfilter(data,J,overlap)
    % [] = INITFILTER(data,range)
    % data - given struct array 
    % J - number of Hanning windows (new number of columns)
    % overlap - percentage of overlap between windows (decimals)
    % data_out - filtered output in the same format as data 

    data_cell = struct2cell(data); % convert to cell matrix
    max_length = @(x) length(x); % function handle to get max length of all elements in cell
    l = cellfun(max_length,data_cell);
    N = max(squeeze(l(3,:,:)),[],'all');
   
    T = floor(N/((1-overlap)*J));
    
    H = zeros(J,N);
    for j = 1:J
        shift = floor((j-1)*(1-overlap)*T);
        H(j,1:T+shift) = [zeros(1,shift) hanning(T)'];
    end
    
    H(:,floor(1:T/2)) = [];
    
    for a = 1:A
        for t = 1:T
            for u = 1:98
                var = data(t,a).spikes(u,:);
                
            end
        end
    end

end