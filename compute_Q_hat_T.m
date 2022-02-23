Q_hat_al_T = ones(T, d, d);
Q_hat_tr_T = ones(T, d, d);
Q_hat_va_T = ones(T, d, d);

for i = 1:T

    Q_hat_al_T(i, :, :) = reshape(squeeze(X_al(i, :, :)), [N, d])' * reshape(squeeze(X_al(i, :, :)), [N, d]) / N;
    Q_hat_tr_T(i, :, :) = reshape(squeeze(X_tr(i, :, :)), [N1, d])' * reshape(squeeze(X_tr(i, :, :)), [N1, d]) / N1;
    Q_hat_va_T(i, :, :) = reshape(squeeze(X_va(i, :, :)), [N2, d])' * reshape(squeeze(X_va(i, :, :)), [N2, d]) / N2;

end
