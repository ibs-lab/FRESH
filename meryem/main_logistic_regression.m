% LOGISTIC REGRESSION
% runs binary logistic regression for each hypothesis separately for one or two
% independent variables with multiple subcategories
%
% TO DO: use the most frequent category as the reference category
% may2024


clear;

% Directory
cd C:\Users\mayucel\Documents\PROJECTS\CODES\FRESH\data

% Flags
flag_display = 1;
flag_reference_category = 0; % sets the most frequent category as the reference category

% Load data from CSV file
filename = 'FreshData.csv';

% Inputs
m = 1;
H_list = 6; %[3, 6, 9, 12, 15, 18, 21,24:63]; % Study I: 3 6 9 12 15 18 21; Study II: 24:63
ProcessingStep = 85;     % Data Quality/Pruning Coding: 76
% Motion Artifact Method Coding: 84
% Motion Artifact Coding: 85
% Filtering Coding: 93
% Stats Coding: 101



for dependentColIndex = H_list
    independentColsIndices = ProcessingStep; % indices of independent variable columns


    % Load at each loop (as we are excluding different rows each time)
    dummy = readtable(filename);
    % Extract dependent variable and corresponding independent variables
    validRows = ~ismissing(dummy{:, dependentColIndex}) & ~strcmp(dummy{:, dependentColIndex}, 'Not investigated');
    dummy = dummy(validRows, :);

    % Exclude columns associated with the dependent variable
    independentColsIndices = setdiff(independentColsIndices, dependentColIndex);

    % Extract data as a cell array
    dependentVar = table2cell(dummy(:,dependentColIndex)); % Create dependent variable
    categories_dep = unique(dependentVar);
    dependentVar = categorical(dependentVar, categories_dep);


    if size(independentColsIndices,2) == 1
        % Convert the cell array to a categorical variable
        independentVar = table2cell(dummy(:,independentColsIndices(1))); % Extract independent variables
        categories_indep = unique(independentVar);
        if flag_reference_category
            categories_indep = swapMostFrequentCategory(independentVar, categories_indep);
        end
        independentVar = categorical(independentVar, categories_indep);

        % Perform logistic regression
        formulaStr = 'dependentVar ~ independentVar'; % Regression formula
        data = table(dependentVar, independentVar); % Create table with variables
        mdl = fitglm(data, formulaStr, 'Distribution', 'binomial', 'Link', 'logit');
    else
        % Convert the cell array to a categorical variable
        independentVar1 = table2cell(dummy(:,independentColsIndices(1))); % Extract independent variables
        independentVar2 = table2cell(dummy(:,independentColsIndices(2))); % Extract independent variables

        categories_indep = unique(independentVar1);
        if flag_reference_category
            categories_indep = swapMostFrequentCategory(independentVar1, categories_indep);
        end
        independentVar1 = categorical(independentVar1, categories_indep);

        categories_indep = unique(independentVar2);
        if flag_reference_category
            categories_indep = swapMostFrequentCategory(independentVar2, categories_indep);
        end
        independentVar2 = categorical(independentVar2, categories_indep);

        formulaStr = 'dependentVar ~ independentVar1 + independentVar2'; % Regression formula with both independent variables
        data = table(dependentVar, independentVar1, independentVar2); % Create table with variables
        mdl = fitglm(data, formulaStr, 'Distribution', 'binomial', 'Link', 'logit');
    end

    % Display summary of the logistic regression model
    if flag_display
        disp(mdl);
    end


    % Make predictions using the model
    predictions = predict(mdl, data);

    % extract pvalues
    mdlc = mdl.Coefficients;
    Pvalues(m,:) = mdlc(2:end,4).Variables;
    m = m+1;
end


%% display number of sign pvalues per category
for i = 1:size(Pvalues,2)
    size(find(Pvalues(:,i)<0.1))
end


%% example
% % Generate sample data
% n = 100; % Number of samples
%
% % Create dependent variable
% dependentVar = categorical(randi([0, 1], n, 1), [0, 1], {'No', 'Yes'});
%
% % Create independent variables
% independentVar1 = categorical(randi([1, 3], n, 1), 1:3, {'A', 'B', 'C'}); % Independent variable 1
% independentVar2 = categorical(randi([4, 5], n, 1), 4:5, {'D', 'E'}); % Independent variable 2
%
% % Perform logistic regression
% formulaStr = 'dependentVar ~ independentVar1 + independentVar2'; % Regression formula with both independent variables
% data = table(dependentVar, independentVar1, independentVar2); % Create table with variables
% mdl = fitglm(data, formulaStr, 'Distribution', 'binomial', 'Link', 'logit');
%
% % Display summary of the logistic regression model
% disp(mdl);
%
% % Make predictions using the model
% predictions = predict(mdl, data);


