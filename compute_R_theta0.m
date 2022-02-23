% ERM
theta0_er = theta0_fun(theta_gt_T, A_er_T);
% R_er(hyper_idx) = pop_risk_fun(theta0_er, theta_gt_T, A_er_T);


% MAML
theta0_ma = theta0_fun(theta_gt_T, A_ma_T);
% R_ma(hyper_idx) = pop_risk_fun(theta0_ma, theta_gt_T, A_ma_T);


% iMAML (biMAML)
theta0_bi = theta0_fun(theta_gt_T, A_bi_T);
% R_bi(hyper_idx) = pop_risk_fun(theta0_bi, theta_gt_T, A_bi_T);


% baMAML
theta0_ba = theta0_fun(theta_gt_T, A_ba_T);
% R_ba(hyper_idx) = pop_risk_fun(theta0_ba, theta_gt_T, A_ba_T);


