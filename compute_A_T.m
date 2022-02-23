A_er_T = ones(T, d, d);
A_ma_T = ones(T, d, d);
A_bi_T = ones(T, d, d);
A_ba_T = ones(T, d, d);

for i = 1:T

    A_er_T(i, :, :) = A_er_t_fun(var_T(i), squeeze(Q_T(i, :, :)));

    A_ma_T(i, :, :) = A_ma_t_fun(var_T(i), squeeze(Q_T(i, :, :)), alpha);

    A_bi_T(i, :, :) = A_bi_t_fun(var_T(i), squeeze(Q_T(i, :, :)), gamma);

    A_ba_T(i, :, :) = A_ba_t_fun(var_T(i), squeeze(Q_T(i, :, :)), gamma, s);

end
