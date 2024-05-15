% This is the main script that reads the data, calls the functions that generate the figures, and
% save the figures in matlab format and jpeg.
% Chnage Line11 to your local directory for the freshdata.csv file.
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
[num, txt ,raw]= xlsread('FreshData.csv'); %


%% plot analysis confidence vs results confidence
fig_analysis_vs_results_conf(num, tofino);




%% save plots
if flag_save
    % Specify the directory to save the figures
    directory = 'C:\Users\mayucel\Documents\PROJECTS\PROJECTS\2021_FRESH\FiguresandTables';

    % Check if the directory exists, if not, create it
    if ~isfolder(dirsave)
        mkdir(dirsave);
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
