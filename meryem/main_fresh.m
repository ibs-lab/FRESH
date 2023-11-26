% This is the main scripts that reads the data, calls the functions that generate the figures, and
% save the figures in matlab format and jpeg.
% Chnage Line11 to your local directory for the freshdata.csv file.
% MAY
clear all;

% flags
flag_save = 0;

% data directory
cd C:\Users\mayucel\Documents\PROJECTS\CODES\FRESH\data

% load excel file
[num, txt ,raw]= xlsread('FreshData.csv'); %


%% extract hypothesis results, and plot variability in hypothesis testing
[H_STUDY_I, H_STUDY_II] = fig_hypothesis_variability(txt);


%% plot analysis confidence vs results confidence
fig_analysis_vs_results_conf(num);


%% plot confidence vs H testing
% plot analysis conf
fig_confidence_vs_hypothesis_conf(num, H_STUDY_I, 1, 1);
fig_confidence_vs_hypothesis_conf(num, H_STUDY_II, 2, 1);

% plot results conf
fig_confidence_vs_hypothesis_conf(num, H_STUDY_I, 1, 0);
fig_confidence_vs_hypothesis_conf(num, H_STUDY_II, 2, 0);


%% plot Sørensen-Dice
% sorensen_dice_matrix = fig_SorensenDice(num, foo, StudyID, flag_analysis, flag_sort, conf_threshold)
sorensen_dice_matrix1 = fig_SorensenDice(num, H_STUDY_I, 1, 1, 1, []);
sorensen_dice_matrix2 = fig_SorensenDice(num, H_STUDY_II, 2, 1, 1, []);


%% save plots
if flag_save
    % Specify the directory to save the figures
directory = 'C:\Users\mayucel\Documents\PROJECTS\PROJECTS\2021_FRESH\Figures'; 

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
    saveas(fig_handles(i), jpeg_filename, 'jpg');
    
    % Save as MATLAB FIG file
    fig_filename = fullfile(directory, ['figure_', num2str(i), '.fig']);
    saveas(fig_handles(i), fig_filename, 'fig');
end

end
