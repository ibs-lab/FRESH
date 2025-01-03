function fig_confidence_vs_hypothesis_conf(num, H_STUDY, StudyID, flag_analysis, cmaps, flag_labels)
% INPUT:
% num: Numerical output read from freshdata.csv
% H_STUDY: output of [H_STUDY_I, H_STUDY_II] = fig_hypothesis_variability(txt);
% StudyID: (1) DatasetI;  (2) DatasetII
% flag_analysis: (1) analysis confidence; (0) results confidence
% MAY

% extract analysis and results confidence
if flag_analysis
    % extracting analysis confidence
    conf = num(StudyID:2:76,126); % they are interleaved starting from 1 (matching StudyID = 1)
else
    % extracting results confidence
    conf = num(StudyID:2:76,127);
end

fooH = H_STUDY;

% remove groups that did not analyze this dataset (NaNs)
ind = ~isnan(conf);
conf = conf(ind);
fooH = fooH(:,ind);

% sort wrt confidence
[out,idx] = sort(conf);
conf = out;
fooH  = fooH (:,idx);


figure;

subplot1 = subplot(1,2,1); imagesc(fooH');
cmap = colormap(subplot1, [cmaps(170,:); cmaps(40,:); 0 0 0]);
xlabel('Hypotheses', 'FontSize',12); ylabel('Groups (ordered by confidence)', 'FontSize',12);
set(gca,'ytick',[])

if StudyID == 1
    xlabel('Hypotheses', 'FontSize',12);
else
    xlabel('Hypotheses x Subjects', 'FontSize',12);
    for column = 0.5 : 10  : 40.5
        line([column, column], [0, 100], 'LineWidth',2, 'Color','black');
    end
end


% Define text positions within the 'grey' area
% x_positions = [0, 0, 0];  % X-coordinates for text
% y_positions = [-2.2 -1.2 -0.2];  % Y-coordinates for text
x_positions = [0.6 1.9 3];  % X-coordinates for text
y_positions = [-1 -1 -1];  % Y-coordinates for text
text_labels = {'Yes', 'No', 'Not Investigated'};  % Labels for text


% Add text annotations with white font color and background color matching cmap
if flag_labels
hold on;
for i = 1:numel(text_labels)
    text(x_positions(i), y_positions(i), text_labels{i}, ...
         'Color', 'white', ...
         'BackgroundColor', cmap(i, :), ...
         'FontSize', 10, ...
         'FontWeight', 'bold', ...
         'Margin', 1); 
end
hold off;
end



% subplot for confidence
subplot2 = subplot(1,2,2);
imagesc(conf);
cmap = colormap(subplot2, gray);
subplot2.Position = [0.51, 0.11, 0.03, 0.815]; % [left, bottom, width, height]

if flag_analysis == 1
    ylabel('Analysis Confidence', 'FontSize',12);
else
    ylabel('Results Confidence', 'FontSize',12);
end
set(gca,'xtick',[])
set(gca,'ytick',[])


% Define text positions within the 'grey' area
x_positions = [1.7, 1.7, 1.7, 1.7];  % X-coordinates for text
text_labels = {'2', '3', '4', '5'};  % Labels for text

if flag_analysis == 1
    y_positions = [1 6 19 30];  % Y-coordinates for text
elseif StudyID == 1 && flag_analysis == 0
    y_positions = [1 8 21 32];  % Y-coordinates for text
else
    y_positions = [1 8 23 32];  % Y-coordinates for text
end


% Add text annotations with specified colors and bold font
hold on;
for i = 1:numel(text_labels)
    text(x_positions(i), y_positions(i), text_labels{i}, 'Color', 'k', 'FontSize', 9, 'FontWeight', 'bold');
end
hold off;



% Display Percent of Teams supporting the hypothesis seperately for low and
% high confidence teams (excluding not investigated)

% Initialize an array to store the percentages for each row

for k = 1:2

percentOnes = zeros(size(fooH,1), 1);

if k == 1
validIndices = find(conf == 1 | conf == 2 | conf == 3);
elseif k == 2
validIndices = find(conf == 4 | conf == 5);
end

% Iterate through each row
for i = 1:size(fooH,1)
    % Extract the relevant columns (12 to 35) for the current row
    dataRow = fooH(i, validIndices);
    
    % Count the number of 1s and 2s in the specified columns
    countOnes = sum(dataRow == 1);
    countTwos = sum(dataRow == 2);
    
    % Calculate the percentage of 1s among 1s and 2s
    totalCount = countOnes + countTwos;
    if totalCount > 0
        percentOnes(i) = (countOnes / totalCount) * 100;
    else
        percentOnes(i) = NaN; % Handle cases where no 1s or 2s exist
    end
end

% Display the results

if k == 1
disp('Teams with Low Confidence')
disp(percentOnes);
elseif k == 2
disp('Teams with High Confidence')
disp(percentOnes);
end


end
