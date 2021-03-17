function [rmse,delays,bw] = grid_search(bw)
    % finding optimal bin width and delay combinations
    delays = [30:10:150];
    L = length(delays);
    rmse = zeros(50, L);
    params = zeros(2, L);
    % length([20:5:90])
    % Progress bar
    f = waitbar(0, 'Processing...');

    p_count = 0;
    for delay = delays
        p_count = p_count + 1;
        fprintf('Set %d/%d \n', p_count, L);
        waitbar(p_count/L, f, 'Processing...');
        for i = 1:50
            rmse(i, p_count)= testFunction_for_students_MTb('kalman', bw, delay);
        end
         params(:, p_count) = delay;
    end
    beep;
    close(f);
end

