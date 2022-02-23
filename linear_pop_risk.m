clear
close all
clc

addpath('./functions/');
addpath('./shaded_plots/');

%% hyperparameters
T = 100;
Nm = 20;

N = 20;

d = 1;
s = .5;

%% generate / load data
TNds.T = T; TNds.N = N; TNds.d = d; TNds.s = s;
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



%% compute risks

Id = eye(d);

A_er_T = ones(T, d, d);
A_ma_T = ones(T, d, d);
A_bi_T = ones(T, d, d);
A_ba_T = ones(T, d, d);

% method hyper

len_hyper = 100;

alpha_all = 0:0.02:2 - 0.02;
gamma_all = 10.^(-5:0.1:4.9);

R_ma = ones(1, len_hyper);
R_bi = ones(1, len_hyper);
R_ba = ones(1, len_hyper);

for hyper_idx = 1:len_hyper

    alpha = alpha_all(hyper_idx);
    gamma = gamma_all(hyper_idx);

    for i = 1:T

        A_er_T(i, :, :) = (1 / var_T(i)) * Q_T(i, :, :);

        A_ma_T(i, :, :) = (Id - alpha * squeeze(A_er_T(i, :, :))) * squeeze(A_er_T(i, :, :)) * ...
            (Id - alpha * squeeze(A_er_T(i, :, :)));
        
        A_bi_T(i, :, :) = inv(Id + (1 / gamma) * squeeze(A_er_T(i, :, :))) * ...
            squeeze(A_er_T(i, :, :)) / (Id + (1 / gamma) * squeeze(A_er_T(i, :, :)));

        A_ba_T(i, :, :) = inv(Id + (1 / gamma / s) * squeeze(A_er_T(i, :, :))) * ...
            squeeze(A_er_T(i, :, :)) / (Id + (1 / gamma) * squeeze(A_er_T(i, :, :))); % gamma * Q_T(i, :, :);

    end

    % MAML 
    theta0_ma = theta0_fun(theta_gt_T, A_ma_T);
    R_ma(hyper_idx) = pop_risk_fun(theta0_ma, theta_gt_T, A_ma_T);
    
    % biMAML
    theta0_bi = theta0_fun(theta_gt_T, A_bi_T);
    R_bi(hyper_idx) = pop_risk_fun(theta0_bi, theta_gt_T, A_bi_T);
    
    % baMAML
    theta0_ba = theta0_fun(theta_gt_T, A_ba_T);
    R_ba(hyper_idx) = pop_risk_fun(theta0_ba, theta_gt_T, A_ba_T);

end

% ERM
theta0_er = theta0_fun(theta_gt_T, A_er_T);
R_er_ = pop_risk_fun(theta0_er, theta_gt_T, A_er_T);
R_er = R_er_ * ones(1, len_hyper);

%% save results

save('./results/linear_pop_risk.mat', ...
    'alpha_all', 'gamma_all', 'R_er', 'R_ma', 'R_ba');

%% plot figure
% population risks vs alpha gamma

load('./results/linear_pop_risk.mat')
define_color;

color_er = color_k;
color_ma = color_g;
color_ba = color_b;
color_bi = color_r;

fontsize = 12;
set(0, 'defaultTextFontName', 'Times')
set(0, 'defaultAxesFontName', 'Times')
set(0, 'defaultAxesFontSize', 12)

linewidth = 2;

f = figure;
f.Position = [10 10 280 300];
t = tiledlayout(1, 1);
ax1 = axes(t);
l1 = line('parent', ax1, 'xdata', alpha_all, 'ydata', R_ma, 'color', color_ma, 'LineStyle', '-', 'LineWidth', linewidth);
l3 = line('parent', ax1, 'xdata', alpha_all, 'ydata', R_er, 'color', color_er, 'LineStyle', '--', 'LineWidth', linewidth);
ax1.XAxisLocation = 'top';
ax1.Color = 'none';

ax1.YColor = 'k';
ax2 = axes(t);
l4 = line('parent', ax2, 'xdata', log10(gamma_all), 'ydata', R_bi, 'color', color_bi, 'LineStyle', '-', 'LineWidth', linewidth);
l2 = line('parent', ax2, 'xdata', log10(gamma_all), 'ydata', R_ba, 'color', color_ba, 'LineStyle', '-', 'LineWidth', linewidth);

ax2.XAxisLocation = 'bottom';
ax2.YAxisLocation = 'left';
ax2.Color = 'none';
ax1.XColor = color_g;
ax2.XColor = color_b;
ax1.Box = 'on';
ax2.Box = 'off';

linkaxes([ax1, ax2], 'y')
xlabel(ax1, '\alpha', 'FontSize', fontsize)

xlabel(ax2, '$\log_{10} (\gamma)$', 'FontSize', fontsize, 'Interpreter', 'latex')
ylabel(ax2, 'Optimal population risk', 'FontSize', fontsize)

legend([l3; l1; l4; l2], {'ERM', 'MAML','iMAML', 'BaMAML'}, 'FontSize', fontsize, 'Location', 'northwest', 'color','none');

exportgraphics(t, './figures/pop_risks.pdf')
