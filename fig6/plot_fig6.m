% This script reads the fresh data and plots Fig 5: hypothesis variability and 
% the Sørensen-Dice plots, displays the relevant statistics, and optionally
% saves the resultant figures in matlab format and jpeg.
% Change Line11 to your local directory for the freshdata.csv file.
% MAY

clear all;

% flags
flag_save = 0;

% Directory - Replace with your local path for FRESH
dirfresh = 'yourlocalpath\FRESH';
addpath(genpath(dirfresh));
dirsave = 'yourlocalpathforsavingfigures';


% load color palette
load CrameriColourMaps7.0.mat;

% load excel file
[num, txt ,raw]= xlsread('FreshData.csv');

%% Extract hypothesis results and plot variability
[H_STUDY_I, H_STUDY_II] = hypothesis_variability(txt);

%% Plot confidence vs hypothesis
fig_confidence_vs_hypothesis_conf(num, H_STUDY_I, 1, 1, tofino, 1);
fig_confidence_vs_hypothesis_conf(num, H_STUDY_II, 2, 1, tofino, 0);
fig_confidence_vs_hypothesis_conf(num, H_STUDY_I, 1, 0, tofino, 0);
fig_confidence_vs_hypothesis_conf(num, H_STUDY_II, 2, 0, tofino, 0);

%% Plot Sørensen-Dice
sorensen_dice_matrix1 = fig_SorensenDice(num, H_STUDY_I, 1, 1, 1, [], tofino);
sorensen_dice_matrix2 = fig_SorensenDice(num, H_STUDY_II, 2, 1, 1, [], tofino);

% Unpaired t-test for similarity matrices
x1 = get_lowerdiagonalelements(sorensen_dice_matrix1);
x2 = get_lowerdiagonalelements(sorensen_dice_matrix2);

% Perform the t-test
[~, p, ci, stats] = ttest2(x1, x2);

% Compute effect size (Cohen's d)
pooled_std = sqrt((std(x1)^2 + std(x2)^2) / 2);
cohen_d = (mean(x1) - mean(x2)) / pooled_std;

% Report results
disp('Statistical test: Unpaired two-sample t-test');
fprintf('t(%d) = %.2f, p = %.4f\n', stats.df, stats.tstat, p);
fprintf('Cohen''s d = %.3f\n', cohen_d);
fprintf('95%% CI for mean difference = [%.3f, %.3f]\n', ci(1), ci(2));
fprintf('Group 1 mean = %.3f, Group 2 mean = %.3f\n', mean(x1), mean(x2));
fprintf('Group 1 n = %d, Group 2 n = %d\n', length(x1), length(x2));

%% Display correlations between confidence/education and hypothesis outcomes
display_corr(num);  % You may want to add CI and rho reporting here too (let me know if you want help modifying it)

%% Save plots if flag enabled
if flag_save
    % Check if the directory exists, if not, create it
    if ~isfolder(dirsave)
        mkdir(dirsave);
    end

    % Get handles to all current figures
    fig_handles = findall(0, 'Type', 'figure');

    % Save each figure as JPEG and MATLAB FIG files
    for i = 1:length(fig_handles)
        jpeg_filename = fullfile(dirsave, ['figure_', num2str(i), '.jpg']);
        resolution = '-r300'; % 300 DPI
        print(fig_handles(i), jpeg_filename, '-djpeg', resolution);

        fig_filename = fullfile(dirsave, ['figure_', num2str(i), '.fig']);
        saveas(fig_handles(i), fig_filename, 'fig');
    end
end
