function F_data = F_analysis(trial,opt)
    % [] = F_ANALYSIS(trial)
        % trial - given struct array 
        % opt - string argument:
            % detrend - fft of detrended data
            % [] - fft of raw data
        % F_data - Fourier transform of data
        
    data = extractfield(trial,'spikes');

    [T,A,U,~] = size(data);

    F_data = NaN(T,A,U,1000);
    for i = 1:1:T
        for j = 1:1:A
            for k = 1:1:U
                var = data(i,j,k,:);
                nonan_len = length(var(~isnan(var)));
                if strcmp(opt,'detrend')
                    x = detrend(squeeze(data(i,j,k,1:1:nonan_len)));
                end
                F_data(i,j,k,1:nonan_len) = abs(fftshift(fft(squeeze(x))));
            end
        end
    end
end

