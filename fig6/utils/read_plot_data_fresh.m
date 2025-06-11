 

% Find all plot objects in the current axis
h = findobj(gca, '-property', 'XData'); 

% Initialize matrices to store X and Y data
x_matrix = [];
y_matrix = [];

% Loop through each plot object and extract the XData and YData
for i = 1:length(h)
    x_values = get(h(i), 'XData'); % Extract x values
    y_values = get(h(i), 'YData'); % Extract y values

    % Concatenate the X and Y data as rows (each row represents a plot group)
    x_matrix = [x_matrix; x_values(:)']; % Add X data
    y_matrix = [y_matrix; y_values(:)']; % Add Y data
end

% Fix the order of columns in y
y_matrix = flipud(y_matrix);

% Save the extracted data to a .mat file
% save('extracted_data.mat', 'x_matrix', 'y_matrix'); 

% Display a message (optional)
disp('Data has been successfully extracted and saved.');

% Plot percent agreement for the motor hypotheses for High_SNR vs Low_SNR
High_SNR = [1,2,6,7,8,9];
Low_SNR = [3,4,5,10];

mean(y_matrix(High_SNR,:))
mean(y_matrix(Low_SNR,:))



%% TWO FEW DATA POINTS TO RUN STATS, BUT KEEPING IT HERE.
% % Data: y_matrix where each column is for a hypothesis and each row is for a subject
% % High SNR group: subjects 1, 2, 6, 7, 8, 9
% % Low SNR group: subjects 3, 4, 5, 10
% 
% % Extract data for the high and low SNR groups
% high_SNR_data = y_matrix(High_SNR, :);
% low_SNR_data = y_matrix(Low_SNR, :);
% 
% % Initialize p-values for each hypothesis
% p_values = zeros(1, size(y_matrix, 2));
% 
% % Loop through each hypothesis (column)
% for i = 1:size(y_matrix, 2)
%     % Perform a t-test or Mann-Whitney U test (based on normality)
%     % Here we will check normality first for each hypothesis
% 
%     % % Check if the data for the current hypothesis is normally distributed
%     % [~, p_high] = swtest(high_SNR_data(:, i));  % Shapiro-Wilk test for normality for High SNR
%     % [~, p_low] = swtest(low_SNR_data(:, i));  % Shapiro-Wilk test for normality for Low SNR
%     % 
%     % if p_high > 0.05 && p_low > 0.05
%         % If both groups are normally distributed, use t-test
%         [~, p_values(i)] = ttest2(high_SNR_data(:, i), low_SNR_data(:, i));
%     % else
%     %     % If either group is not normally distributed, use Mann-Whitney U test
%     %     [p_values(i)] = ranksum(high_SNR_data(:, i), low_SNR_data(:, i));
%     % end
% end
% 
% % Display p-values for each hypothesis
% disp('p-values for each hypothesis:');
% disp(p_values);

