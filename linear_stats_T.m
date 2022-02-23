clear
close all
clc

addpath('./functions/');
%% hyperparameters

beta = 1;
% beta = random('Uniform', 0.1, 2);

Tm = 1e5;
N = 10;
d = 1;
s = .5;

T_all = round(10.^(-4.4:0.02:0) * Tm);

alpha = 0.7;
gamma = 1e1;

%% generate / load data
TNds.T = Tm; TNds.N = N; TNds.d = d; TNds.s = s;
dataname = get_dataname(TNds);

filename = ['./data/', dataname, '.mat'];

if exist(filename, 'file')
    load(filename);
    disp(['load data from ', filename]);
else
    dataname = generate_data_trn_val(TNds);
    load(filename);
    disp(['generate and save data ', filename]);
end

Q_T__ = datagen_para.Q_T;
var_T__ = datagen_para.var_T;
theta_gt_T__ = datagen_para.theta_gt_T;

X__ = data_Xye.X_all;
y__ = data_Xye.y_all;
eps__ = data_Xye.eps_all;

%% get stats err

exp_num = 10;
T_num = length(T_all);

stats_err_er = zeros(exp_num, T_num);
stats_err_ma = zeros(exp_num, T_num);
stats_err_bi = zeros(exp_num, T_num);
stats_err_ba = zeros(exp_num, T_num);

for exp_idx = 1:exp_num
    Tm_perm = randperm(Tm);

    theta_gt_T_ = theta_gt_T__(Tm_perm, :);
    var_T_ = var_T__(Tm_perm, :);
    Q_T_ = Q_T__(Tm_perm, :, :);

    X_ = X__(Tm_perm, :, :);
    eps_ = eps__(Tm_perm, :, :);
    y_ = y__(Tm_perm, :, :);

    theta0_hat_er = zeros(d, T_num);
    theta0_hat_ma = zeros(d, T_num);
    theta0_hat_bi = zeros(d, T_num);
    theta0_hat_ba = zeros(d, T_num);

    for hyper_idx = 1:T_num

        T = T_all(hyper_idx);

        theta_gt_T = theta_gt_T_(1:T, :);
        var_T = var_T_(1:T, :);
        Q_T = Q_T_(1:T, :, :);

        N1 = round(s * N);
        N2 = N - N1;

        X_al = X_(1:T, 1:N, :); y_al = y_(1:T, 1:N); eps_al = eps_(1:T, 1:N);
        X_tr = X_al(:, 1:N1, :); y_tr = y_al(:, 1:N1); eps_tr = eps_al(:, 1:N1);
        X_va = X_al(:, N1 + 1:N, :); y_va = y_al(:, N1 + 1:N); eps_va = eps_al(:, N1 + 1:N);

        %% compute risks

        Id = eye(d);

        compute_A_T;
        compute_Q_hat_T;
        compute_A_hat_T;

        compute_R_theta0_theta0_hat;

    end

    stats_err_er(exp_idx, :) = sum((theta0_er - theta0_hat_er).^2,1);
    stats_err_ma(exp_idx, :) = sum((theta0_ma - theta0_hat_ma).^2,1);
    stats_err_bi(exp_idx, :) = sum((theta0_bi - theta0_hat_bi).^2,1);
    stats_err_ba(exp_idx, :) = sum((theta0_ba - theta0_hat_ba).^2,1);

    
end


%% save results
TNds_T = TNds;
stats_err_T.er = stats_err_er;
stats_err_T.ma = stats_err_ma;
stats_err_T.bi = stats_err_bi;
stats_err_T.ba = stats_err_ba;
save('./results/linear_stats_err_T.mat', ...
    'TNds_T', ...
    'T_all', 'stats_err_T');


