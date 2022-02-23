A_hat_er_T = ones(T, d, d);
A_hat_ma_T = ones(T, d, d);
A_hat_bi_T = ones(T, d, d);
A_hat_ba_T = ones(T, d, d);

Sig_q_inv_t = ones(T, d, d);
Sig_qs_inv_t = ones(T, d, d);
% Sig_pos_inv_t = ones(T, d, d);
% mu_pos_t = ones(T, d);

for i = 1:T

    A_hat_er_T(i, :, :) = (1 / var_T(i)) * Q_hat_al_T(i, :, :);

    A_hat_ma_T(i, :, :) = 1 / var_T(i) * (Id -alpha / var_T(i) * squeeze(Q_hat_tr_T(i, :, :))) * ...
        squeeze(Q_hat_va_T(i, :, :)) * (Id -alpha / var_T(i) * squeeze(Q_hat_tr_T(i, :, :)));

    Sig_q_inv_t(i, :, :) = (1 / gamma / var_T(i)) * squeeze(Q_hat_tr_T(i, :, :)) + Id;
    A_hat_bi_T(i, :, :) = (1 / var_T(i)) * inv(squeeze(Sig_q_inv_t(i, :, :))) * ...
       squeeze( Q_hat_va_T(i, :, :)) / squeeze(Sig_q_inv_t(i, :, :));

    Sig_qs_inv_t(i, :, :) = (1 / gamma / s / var_T(i)) * squeeze(Q_hat_al_T(i, :, :)) + Id;
    A_hat_ba_T(i, :, :) = (1 / var_T(i)) * inv(squeeze(Sig_qs_inv_t(i, :, :))) * ...
       squeeze( Q_hat_va_T(i, :, :)) / squeeze(Sig_q_inv_t(i, :, :));

end
