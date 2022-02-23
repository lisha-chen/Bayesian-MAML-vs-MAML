function A_ma_t = A_ma_t_fun(var_t, Q_t, alpha)

    d = size(Q_t, 1);
    Id = eye(d);
    A_er_t = A_er_t_fun(var_t, Q_t);

    A_ma_t = (Id - alpha * A_er_t) * A_er_t * ...
        (Id - alpha * A_er_t);

end
