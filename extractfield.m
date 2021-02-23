function data_out = extractfield(data,field)
    % [] = EXTRACTFIELD(data,field)
        % data - given struct array 
        % field - string argument: 
            % 'spikes' - EEG data
            % 'handPos' - X-Y-Z position of hand
            % 'trialId' - trial ID
        % data_out - extracted field as a matrix or tensor
            
    [T,A] = size(data);
            
    if strcmpi(field,'spikes')
        
        data_out = NaN(T,A,98,1000);
        for i = 1:1:T
            for j = 1:1:A
                n = length(data(i,j).spikes);
                data_out(i,j,:,1:n) = data(i,j).spikes;
            end
        end
        
    elseif strcmpi(field,'handPos')
        
        data_out = NaN(T,A,3,1000);
        for i = 1:1:T
            for j = 1:1:A
                n = length(data(i,j).handPos);
                data_out(i,j,:,1:n) = data(i,j).handPos;
            end
        end
        
    elseif strcmpi(field,'trialId')
        
        data_out = NaN(T,A);
        for i = 1:1:T
            for j = 1:1:A
                n = length(data(i,j).spikes);
                data_out(i,j) = data(i,j).trialId;
            end
        end
        
    else 
        error('Invalid syntax: *field* must represent a field present in the struct')
    end
    
            
end

