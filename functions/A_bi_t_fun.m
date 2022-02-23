function A_bi_t = A_bi_t_fun(var_t, Q_t, gamma)

    d = size(Q_t, 1);
    Id = eye(d);
    A_er_t = A_er_t_fun(var_t, Q_t);

    A_bi_t = inv(Id + (1 / gamma) * A_er_t) * ...
        A_er_t / (Id + (1 / gamma) * A_er_t);

end
