% ERM
theta0_er = theta0_fun(theta_gt_T, A_er_T);
R_er(hyper_idx) = pop_risk_fun(theta0_er, theta_gt_T, A_er_T);

Xy_al_T = zeros(T, d);

for i = 1:T
    Xy_al_T(i, :) = 1 / var_T(i) * reshape(squeeze(X_al(i, :, :)), [N,d])' * y_al(i, :)' / N;
end
theta0_hat_er(:, hyper_idx) = (squeeze(mean(A_hat_er_T, 1))) \ mean(Xy_al_T, 1)';


% MAML

Xy_tr_T = zeros(T, d);
for i = 1:T
    Xy_tr_T(i, :) = 1 / var_T(i) * reshape(squeeze(X_tr(i, :, :)), [N1,d])' * y_tr(i, :)' / N1;
end
Xy_va_T = zeros(T, d);
for i = 1:T
    Xy_va_T(i, :) = 1 / var_T(i) * reshape(squeeze(X_va(i, :, :)), [N2,d])' * y_va(i, :)' / N2;
end

theta0_ma = theta0_fun(theta_gt_T, A_ma_T);
R_ma(hyper_idx) = pop_risk_fun(theta0_ma, theta_gt_T, A_ma_T);

ma_Xy_T = zeros(T, d);
for i = 1:T
    ma_Xy_T(i, :) = (Id - alpha / var_T(i) * squeeze(Q_hat_tr_T(i,:,:))) * ...
        (Xy_va_T(i, :)' -alpha/ var_T(i) * squeeze(Q_hat_va_T(i,:,:)) * Xy_tr_T(i, :)');
end
theta0_hat_ma(:, hyper_idx) = (squeeze(mean(A_hat_ma_T, 1))) \ mean(ma_Xy_T, 1)';


% iMAML (biMAML)
theta0_bi = theta0_fun(theta_gt_T, A_bi_T);
R_bi(hyper_idx) = pop_risk_fun(theta0_bi, theta_gt_T, A_bi_T);

bi_Xy_T = zeros(T, d);
for i = 1:T
    bi_Xy_T(i, :) = inv(squeeze(Sig_q_inv_t(i,:,:))) * (Xy_va_T(i, :)' ...
        - squeeze(Q_hat_va_T(i,:,:)) / gamma / var_T(i) * (squeeze(Sig_q_inv_t(i,:,:))\ Xy_tr_T(i, :)')) ;
end
theta0_hat_bi(:, hyper_idx) = squeeze(mean(A_hat_bi_T, 1)) \ mean(bi_Xy_T, 1)';

% baMAML
theta0_ba = theta0_fun(theta_gt_T, A_ba_T);
R_ba(hyper_idx) = pop_risk_fun(theta0_ba, theta_gt_T, A_ba_T);

ba_Xy_T = zeros(T, d);
for i = 1:T
    ba_Xy_T(i, :) = squeeze(Sig_qs_inv_t(i,:,:)) \ Xy_al_T(i, :)' / (1-s) - ...
        squeeze(Sig_q_inv_t(i,:,:)) \ Xy_tr_T(i, :)' * s / (1-s);
end
theta0_hat_ba(:, hyper_idx) = squeeze(mean(A_hat_ba_T, 1)) \ mean(ba_Xy_T, 1)';



