clear
close all
clc

addpath('./functions/');

%% hyperparameters

T = 100;
Nm = 1e5;
d = 1;
s = .5;

N_all = round(10.^(-4.4:0.02:0) * Nm);

alpha = 0.7;
gamma = 1e1;

%% generate / load data
TNds.T = T; TNds.N = Nm; TNds.d = d; TNds.s = s;
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

Q_T = datagen_para.Q_T;
var_T = datagen_para.var_T;
theta_gt_T = datagen_para.theta_gt_T;

X__ = data_Xye.X_all;
y__ = data_Xye.y_all;
eps__ = data_Xye.eps_all;


%% get stats err
exp_num = 10;
N_num = length(N_all);

stats_err_er = zeros(exp_num, N_num);
stats_err_ma = zeros(exp_num, N_num);
stats_err_bi = zeros(exp_num, N_num);
stats_err_ba = zeros(exp_num, N_num);

for exp_idx = 1:exp_num
    Nm_perm = randperm(Nm);

    X_ = X__(:, Nm_perm, :);
    eps_ = eps__(:, Nm_perm);
    y_ = y__(:, Nm_perm);

    theta0_hat_er = zeros(d, N_num);
    theta0_hat_ma = zeros(d, N_num);
    theta0_hat_bi = zeros(d, N_num);
    theta0_hat_ba = zeros(d, N_num);

    R_er = zeros(1, N_num);
    R_ma = zeros(1, N_num);
    R_bi = zeros(1, N_num);
    R_ba = zeros(1, N_num);

    for hyper_idx = 1:N_num

        N = N_all(hyper_idx);
        N1 = round(s * N);
        N2 = N - N1;

        X_al = X_(:, 1:N, :); y_al = y_(:, 1:N); eps_al = eps_(:, 1:N);
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

    % check_hat(exp_idx,:) = (theta0_hat_ba1 - theta0_hat_ba).^2;
    % max(check_hat(:))
end

%% save results
TNds_N = TNds;
stats_err_N.er = stats_err_er;
stats_err_N.ma = stats_err_ma;
stats_err_N.bi = stats_err_bi;
stats_err_N.ba = stats_err_ba;

save('./results/linear_stats_err_N.mat', ...
    'TNds_N', ...
    'N_all', 'stats_err_N');

