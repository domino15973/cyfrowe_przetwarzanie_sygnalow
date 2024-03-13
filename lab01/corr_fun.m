function correlation_vector = corr_fun(x, y)
    % Lengths of vectors
    n = length(x);
    m = length(y);

    % Mean values of both vectors
    x_mean = mean(x);
    y_mean = mean(y);

    % Standard deviations
    x_std = std(x);
    y_std = std(y);

    correlation_vector = zeros(1, n + m - 1);
    lags = -n + 1:m;

    % Calculating correlation by traversing each element
    for i = 1:length(correlation_vector)
        if lags(i) < 0
            correlation_vector(i) = sum((x(1:n + lags(i)) - x_mean) .* (y(-lags(i) + 1:m) - y_mean));
        elseif lags(i) == 0
            correlation_vector(i) = sum((x - x_mean) .* (y - y_mean));
        else
            correlation_vector(i) = sum((x(lags(i) + 1:n) - x_mean) .* (y(1:m - lags(i)) - y_mean));
        end
        % Normalization
        correlation_vector(i) = correlation_vector(i) / (x_std * y_std * (n - abs(lags(i))));
    end
end



