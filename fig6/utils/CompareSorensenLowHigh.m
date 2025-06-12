% Compares sorensen low (2 3) to sorensen high for Group I and II
% MAY

clear all;

% Flags
flag_save = 0;

% Directory setup
dirfresh = 'yourlocalpath\FRESH';
addpath(genpath(dirfresh));
dirsave = 'yourlocalpathforsavingfigures';

% Load color palette
load CrameriColourMaps7.0.mat;

% Load data
[num, txt ,raw] = xlsread('FreshData.csv');

% Extract hypothesis results
[H_STUDY_I, H_STUDY_II] = hypothesis_variability(txt);

%% -- Function to compute and display Sørensen-Dice stats --
compute_dice_stats = @(study_name, H_STUDY, study_id) ...
    deal_dice_stats(num, H_STUDY, study_id, tofino, study_name);

% Run for Study I and Study II
compute_dice_stats('Study I', H_STUDY_I, 1);
compute_dice_stats('Study II', H_STUDY_II, 2);

%% Function Definition
function deal_dice_stats(num, H_STUDY, study_id, cmap, label)

    % Low confidence groups: levels 2 and 3
    x2 = get_lowerdiagonalelements(fig_SorensenDice(num, H_STUDY, study_id, 1, 1, 2, cmap));
    x3 = get_lowerdiagonalelements(fig_SorensenDice(num, H_STUDY, study_id, 1, 1, 3, cmap));
    lowS = [x2; x3];

    % High confidence groups: levels 4 and 5
    x4 = get_lowerdiagonalelements(fig_SorensenDice(num, H_STUDY, study_id, 1, 1, 4, cmap));
    x5 = get_lowerdiagonalelements(fig_SorensenDice(num, H_STUDY, study_id, 1, 1, 5, cmap));
    highS = [x4; x5];

    % T-test
    [~, p, ci, stats] = ttest2(lowS, highS);

    % Cohen's d
    n1 = length(lowS); n2 = length(highS);
    mean1 = mean(lowS); mean2 = mean(highS);
    std_pooled = sqrt(((n1 - 1)*var(lowS) + (n2 - 1)*var(highS)) / (n1 + n2 - 2));
    cohen_d = (mean1 - mean2) / std_pooled;

    % Display results
    fprintf('\n%s: Sørensen-Dice similarity comparison\n', label);
    fprintf('two-sided unpaired t-test, t = %.1f, p = %s, Cohen''s d = %.2f, 95%% CI [%.3f, %.3f]\n', ...
        stats.tstat, pval2str(p), cohen_d, ci(1), ci(2));
    fprintf('Mean ± SD (Low Confidence): %.2f ± %.2f, n = %d\n', mean1, std(lowS), n1);
    fprintf('Mean ± SD (High Confidence): %.2f ± %.2f, n = %d\n', mean2, std(highS), n2);
end

%% Helper function for clean p-value display
function str = pval2str(p)
    if p < 0.001
        str = '< 0.001';
    else
        str = sprintf('%.3f', p);
    end
end
