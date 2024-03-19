% This is the main script that reads the data, calls the functions that generate the figures, and
% save the figures in matlab format and jpeg.
% Chnage Line11 to your local directory for the freshdata.csv file.
% MAY
clear all;

% flags
flag_save = 0;

% Directory
dirdata = 'C:\Users\mayucel\Documents\PROJECTS\CODES\FRESH\data';
addpath(genpath(dirdata));
dircode = 'C:\Users\mayucel\Documents\PROJECTS\CODES\FRESH\meryem';
addpath(genpath(dircode));

% load color palette
load CrameriColourMaps7.0.mat;

% load excel file
[num, txt ,raw]= xlsread('FreshData.csv'); %


%% extract hypothesis results, and plot variability in hypothesis testing
[H_STUDY_I, H_STUDY_II] = fig_hypothesis_variability(txt);


%% plot analysis confidence vs results confidence
fig_analysis_vs_results_conf(num, tofino);


%% plot confidence vs H testing
% plot analysis conf
fig_confidence_vs_hypothesis_conf(num, H_STUDY_I, 1, 1, tofino, 1);
fig_confidence_vs_hypothesis_conf(num, H_STUDY_II, 2, 1, tofino, 0);

% plot results conf
fig_confidence_vs_hypothesis_conf(num, H_STUDY_I, 1, 0, tofino, 0);
fig_confidence_vs_hypothesis_conf(num, H_STUDY_II, 2, 0, tofino, 0);


%% plot Sørensen-Dice
% sorensen_dice_matrix = fig_SorensenDice(num, foo, StudyID, flag_analysis, flag_sort, conf_threshold)
sorensen_dice_matrix1 = fig_SorensenDice(num, H_STUDY_I, 1, 1, 1, [], tofino);
sorensen_dice_matrix2 = fig_SorensenDice(num, H_STUDY_II, 2, 1, 1, [], tofino);
% unpaired ttest comparing sorensen for study 1 vs study 2. Get the full
% matrix from above i.e. use [] above.
[h, p] = ttest2(get_lowerdiagonalelements(sorensen_dice_matrix1), get_lowerdiagonalelements(sorensen_dice_matrix2));
disp('Unpairded t-test results for the comparison of similarity values between STUDY I and STUDY II:');
disp(['h:', num2str(h)]);
disp(['p:', num2str(p)]);

%% display corr between analysis/results confidence and education
display_corr(num);

%% save plots
if flag_save
    % Specify the directory to save the figures
    directory = 'C:\Users\mayucel\Documents\PROJECTS\PROJECTS\2021_FRESH\FiguresandTables';

    % Check if the directory exists, if not, create it
    if ~isfolder(directory)
        mkdir(directory);
    end

    % Get handles to all current figures
    fig_handles = findall(0, 'Type', 'figure');

    % Save each figure as JPEG and MATLAB FIG files
    for i = 1:length(fig_handles)

        % Save as JPEG
        jpeg_filename = fullfile(directory, ['figure_', num2str(i), '.jpg']);
        resolution = '-r300'; % For example, 300 DPI
        print(fig_handles(i), jpeg_filename, '-djpeg', resolution);


        % Save as MATLAB FIG file
        fig_filename = fullfile(directory, ['figure_', num2str(i), '.fig']);
        saveas(fig_handles(i), fig_filename, 'fig');

    end

end
