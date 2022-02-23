function theta0 = theta0_fun(theta_gt_T, A_T)

    T = size(A_T, 1);
    sum_theta = 0;

    for i = 1:T
        sum_theta = sum_theta + squeeze(A_T(i, :, :)) * theta_gt_T(i, :)';
    end
    mean_theta = sum_theta / T;

    theta0 = squeeze(mean(A_T, 1)) \ mean_theta;

end
