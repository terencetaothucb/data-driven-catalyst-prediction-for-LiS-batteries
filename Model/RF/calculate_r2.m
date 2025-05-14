function r2 = calculate_r2(y_true, y_pred)
    % Ensure inputs are column vectors
    assert(iscolumn(y_true) && iscolumn(y_pred), 'Inputs must be column vectors');

    % Calculate the total sum of squares
    ss_total = sum((y_true - mean(y_true)).^2);

    % Calculate the residual sum of squares
    ss_res = sum((y_true - y_pred).^2);

    % Calculate R-squared
    r2 = 1 - (ss_res / ss_total);
end
