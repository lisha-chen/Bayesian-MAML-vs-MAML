function R = pop_risk_fun(theta0, theta_gt, A_t)

    % theta_gt: T*d
    % A_t: T*d*d
    % R = 1 + mean((theta0 - theta_gt) .^ 2 .* A_t );
    T = size(theta_gt, 1);
    R = 0;

    for i = 1:T
        R = R + (theta0 - theta_gt(i, :)')' * squeeze(A_t(i, :, :)) * (theta0 - theta_gt(i, :)');
    end

    R = R / T + 1;

end
