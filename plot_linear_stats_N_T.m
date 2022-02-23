clear
close all
clc

%% compute ref para

R = (2-0)/sqrt(12); %U[0,2]
var_T = 0.3;

T=10; N=10; d=1;
alpha = 0.7;
gamma = 1e-1;

w_er = 1/var_T;
w_ma = (1 - alpha * var_T)^2 / var_T;
w_ba = 1/(1 + 1/gamma/var_T) / var_T;


%% load results
load('./results/linear_stats_err_N.mat')
load('./results/linear_stats_err_T.mat')

%% figure setting
addpath('./shaded_plots/');
define_color;

color_er = color_k;
color_ma = color_g;
color_ba = color_b;
color_bi = color_r;

linew = 1;
fontsize = 14;
set(0, 'defaultTextFontName', 'Times')
set(0, 'defaultAxesFontName', 'Times')

alpha_shade = 0.1;

const = 2;

%% plot
f = figure;
f.Position = 10+[0 0 600 300];
colororder([color_k; color_r])

t = tiledlayout(1, 2);
t.TileSpacing = 'tight';
t.Padding = 'tight';

ax1 = axes(t);
ax1.XAxisLocation = 'bottom';
ax1.YAxisLocation = 'left';
ax1.XColor = 'k';
ax1.YColor = 'k';
ax1.Box = 'on';


annotation('textarrow',[0.25,0.2], [0.8,0.8],'String','$-\log_{10}N + const.$','FontSize', fontsize - 2, ...
    'HeadLength',5,'HeadWidth',3,'HeadStyle','plain','Interpreter', 'latex')
hold on;
% xlabel('log Number of data per task (log_{10}(N))','FontSize',14);
% ylabel('log Statistical error','FontSize',14);

xlabel((['$\log_{10}N $']), 'FontSize', fontsize, 'Interpreter', 'latex');
ylabel('$\log_{10} || \theta_0 - \hat{\theta}_0 ||_2^2$', 'FontSize', fontsize, 'Interpreter', 'latex');
title(['$T=', num2str(TNds_N.T), ', s=', num2str(TNds_T.s), '$'], ...
    'FontSize', fontsize, 'Interpreter', 'latex');



l_N_ref_er = plot(log10(N_all), -1.*log10(N_all) + const, 'parent', ax1, 'Color', 'k', ...
    'LineStyle', ':', 'LineWidth', linew);
hold on;

plot_idx = 1:2:length(N_all);

l_N_ma = plot_stats(log10(N_all(:, plot_idx)), log10(stats_err_N.ma(:, plot_idx)), 'parent', ax1, 'Color', color_ma, ...
    'Alpha', alpha_shade, 'LineStyle', '-', 'LineWidth', linew);
l_N_ba = plot_stats(log10(N_all(:, plot_idx)), log10(stats_err_N.ba(:, plot_idx)), 'parent', ax1, 'Color', color_ba, ...
    'Alpha', alpha_shade, 'LineStyle', '-', 'LineWidth', linew);
l_N_er = plot_stats(log10(N_all(:, plot_idx)), log10(stats_err_N.er(:, plot_idx)), 'parent', ax1, 'Color', color_er, ...
    'Alpha', alpha_shade, 'LineStyle', '--', 'LineWidth', linew);

l_N_bi = plot_stats(log10(N_all(:, plot_idx)), log10(stats_err_N.bi(:, plot_idx)), 'parent', ax1, 'Color', color_bi, ...
    'Alpha', alpha_shade, 'LineStyle', '-', 'LineWidth', linew);

% yliml = get(gca,'Ylim');ratio = yliml(1)/yliml(2);
% ylimmin = round(min(mean(log10(stats_err_N.er), 1)) - 1);
% ylimmax = round(max(mean(log10(stats_err_N.bi), 1)) );
ylimmin = -7;
ylimmax = const - 0.5;
set(gca, 'Ylim', [ylimmin, ylimmax]);
set(gca, 'Xlim', [0.5, 5]);




% ylimmin = round(min(mean(log10(stats_err_N.bi), 1)) - 1);
% ylimmax = round(max(mean(log10(stats_err_N.bi), 1)) + 1);
% set(gca, 'Ylim', [ylimmin, ylimmax]);
% set(gca, 'Xlim', [0.5, 5]);

ax2 = nexttile;
ax2.XAxisLocation = 'bottom';
ax2.YAxisLocation = 'left';
ax2.XColor = 'k';
ax2.YColor = 'k';
ax2.Box = 'on';



l_T_ref_er = plot(log10(T_all), -log10(T_all) + const , 'parent', ax2, 'Color', 'k', ...
    'LineStyle', ':', 'LineWidth', linew);
hold on;
plot_idx = 1:2:length(T_all);
l_T_ma = plot_stats(log10(T_all(:, plot_idx)), log10(stats_err_T.ma(:, plot_idx)), 'parent', ax2, 'Color', color_ma, ...
    'Alpha', alpha_shade, 'LineStyle', '-', 'LineWidth', linew);
l_T_ba = plot_stats(log10(T_all(:, plot_idx)), log10(stats_err_T.ba(:, plot_idx)), 'parent', ax2, 'Color', color_ba, ...
    'Alpha', alpha_shade, 'LineStyle', '-', 'LineWidth', linew);
l_T_er = plot_stats(log10(T_all(:, plot_idx)), log10(stats_err_T.er(:, plot_idx)), 'parent', ax2, 'Color', color_er, ...
    'Alpha', alpha_shade, 'LineStyle', '--', 'LineWidth', linew);

l_T_bi = plot_stats(log10(T_all(:, plot_idx)), log10(stats_err_T.bi(:, plot_idx)), 'parent', ax2, 'Color', color_bi, ...
    'Alpha', alpha_shade, 'LineStyle', '-', 'LineWidth', linew);


xlabel((['$\log_{10}T $']), 'FontSize', fontsize, 'Interpreter', 'latex');
title(['$N=', num2str(TNds_T.N), ', s=', num2str(TNds_T.s), '$'], ...
    'FontSize', fontsize, 'Interpreter', 'latex');

ylimmin = -7;
ylimmax = const - 0.5;
set(gca, 'Ylim', [ylimmin, ylimmax]);
set(gca, 'Xlim', [0.5, 5]);



% ylimmin = round(min(mean(log10(stats_err_T.bi), 1)) - 1);
% ylimmax = round(max(mean(log10(stats_err_T.bi), 1)) + 1);
% set(gca, 'Ylim', [ylimmin, ylimmax]);
% set(gca, 'Xlim', [0.5, 5]);


legend([l_T_er; l_T_ma; l_T_bi; l_T_ba], {'ERM', 'MAML', 'iMAML', 'BaMAML'}, ...
    'Location', 'southwest', 'FontSize', fontsize - 2, ...
    'Interpreter', 'latex', 'color','none');



annotation('textarrow',[0.75,0.7], [0.8,0.8],'String','$-\log_{10}T + const.$','FontSize', fontsize - 2, ...
    'HeadLength',5,'HeadWidth',3,'HeadStyle','plain','Interpreter', 'latex')
%$-\log_{10}T+\log_{10}R^2$


exportgraphics(t, './figures/log_stats_err_vs_N_T_ref.pdf')
