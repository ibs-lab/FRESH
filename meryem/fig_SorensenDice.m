function sorensen_dice_matrix = fig_SorensenDice(num, foo, StudyID, flag_analysis, flag_sort, conf_threshold, cmap)
% generates Sørensen-Dice Similarity Matrix
% Define your vectors (each row represents a vector with categorical values 1, 2, or 3)
% e.g. sorensen_dice_matrix = SorensenDice(H_STUDY_I)
% INPUTS
% StudyID: 1/2
% flag_analysis: (1) analysis conf; (0) results confidence
% flag_sort: sorts groups by confidence
% conf_threshold: limit sorensen matrix to a single conf level. Note: to include all groups, put []
% cmap

% exclude groups that did not investigate any of the hypotheses for the given dataset
% column = find(all(foo == 3));
% vectors = foo(:,setdiff(1:end,column))';
% MAY and ChatGPT:)


% extract analysis and results confidence
if flag_analysis
    % extracting analysis confidence
    conf = num(StudyID:2:76,126); % they are interleaved starting from 1 (matching StudyID = 1)
    ind = find(~isnan(conf));
else
    % extracting results confidence
    conf = num(StudyID:2:76,127);
    ind = find(~isnan(conf));
end

if flag_sort
    vectors = foo(:, ind);
    conf = conf(ind);
    % sort wrt confidence
    [out,idx] = sort(conf);
    conf = out;
    vectors  = vectors(:,idx)';
else
    vectors = vectors';
end

% Initialize a matrix to store Sørensen-Dice similarities
num_vectors = size(vectors, 1);
sorensen_dice_matrix = zeros(num_vectors, num_vectors);

% Calculate Sørensen-Dice similarity for all pairs of vectors
for i = 1:num_vectors
    for j = 1:num_vectors
        set1 = vectors(i, :); % Vector i
        set2 = vectors(j, :); % Vector j
        intersection = sum(set1 == set2); % Count matching elements
        sorensen_dice_matrix(i, j) = 2 * intersection / (numel(set1) + numel(set2)); % Calculate Sørensen-Dice similarity
    end
end

% unpairded t-test to compare similarity between conf(2 and 3) and conf(4 and 5)
sorensen_dice_matrix23 = sorensen_dice_matrix(find(conf<4),find(conf<4));
sorensen_dice_matrix45 = sorensen_dice_matrix(find(conf>=4),find(conf>=4));
elementsBelowDiagonal_23 = get_lowerdiagonalelements(sorensen_dice_matrix23);
elementsBelowDiagonal_45 = get_lowerdiagonalelements(sorensen_dice_matrix45);

[h, p] = ttest2(elementsBelowDiagonal_23, elementsBelowDiagonal_45);
disp('Unpairded t-test results for the comparison of similarity values between conf(2 and 3) and conf(4 and 5):');
disp(['h:', num2str(h)]);
disp(['p:', num2str(p)]);

% if conf_theshold, reduce the sorensen matrix to the values that belong to
% that confidence level
if conf_threshold
sorensen_dice_matrix = sorensen_dice_matrix(find(conf==conf_threshold),find(conf==conf_threshold));
num_vectors = size(sorensen_dice_matrix,1);
else
end

% Calculate mean of elements below the diagonal
elementsBelowDiagonal = get_lowerdiagonalelements(sorensen_dice_matrix);
meanBelowDiagonal = mean(elementsBelowDiagonal);
stdBelowDiagonal = std(elementsBelowDiagonal);
disp('Mean and Std of the SD elements below the diagonal (excluding diagonal):');
disp(meanBelowDiagonal);
disp(stdBelowDiagonal);

% setting very high values of tofino  colormap to green (was yellow)
for i = 200:256; cmap(i,:) = cmap(200,:); end

% Visualize the Sørensen-Dice similarity matrix using a heatmap
figure;
heatmap(sorensen_dice_matrix, 'Colormap', cmap, 'FontSize', 10, ...
    'XData', 1:num_vectors, 'YData', 1:num_vectors, 'ColorbarVisible', 'on');
clim([0.5 1]);
xlabel('Groups (ordered by confidence)');
ylabel('Groups (ordered by confidence)');
title('Sørensen-Dice Similarity Matrix');
