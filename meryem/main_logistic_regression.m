% LOGISTIC REGRESSION
% runs binary logistic regression for each hypothesis separately for one (logistic regression)
% or any combination of independent variables with multiple subcategories (multiple logistic
% regression)
%
% may2024


clear;

% Directory
dirdata = 'C:\Users\mayucel\Documents\PROJECTS\CODES\FRESH\data';
addpath(genpath(dirdata));
dircode = 'C:\Users\mayucel\Documents\PROJECTS\CODES\FRESH\meryem';
addpath(genpath(dircode));


% Flags
flag_display = 1;
flag_reference_category = 1; % sets the most frequent category as the reference category
flag_display_pvalue = 1;
flag_chi2_test = 1; % performing chi-square test to check multicollinearity between independent variables

% Load data from CSV file
filename = 'FreshData.csv';

% Inputs
p_threshold = 0.05;
m = 1;
H_list = [3, 6, 9, 12, 15, 18, 21,24:63]; % Study I: 3 6 9 12 15 18 21; Study II: 24:63
ProcessingStep = 122;
% Data Quality/Pruning Coding: 76 ++
% Motion Artifact Coding: 85 ++
% Filtering Coding: 93 ++
% Stats Coding: 101 ++
% Stat Analysis: Signal Space:113  ++
% GLM Method: 103
% GLM HRF Regressor: 106  ++
% Statistical Analysis Method: 111
% Multiple Comparisons: 122
% Motion Artifact Method Coding: 84 this one a bit tricky, not each H has
% all categories, so breaking Pvalue line. Checked all pvalues for this,
% none significant.




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


    numIndependentVars = numel(ProcessingStep);

    for i = 1:numIndependentVars
        variableName = ['independentVar', num2str(i)];
        variableIndex = independentColsIndices(i);

        % Extract independent variable and create dynamic variable
        eval([variableName, ' = table2cell(dummy(:, variableIndex));']);

        % Handle categories
        categories_indep = unique(eval(variableName));
        if flag_reference_category
            if ProcessingStep == 122 % Multiple Comparison
                categories_indep = {'N/A';'Benjamini-Yekutieli';'Bonferroni';'Benjamini-Hochberg'};
                % Note: Both N/A and Benjamini-Hochberg have same
                % frequency, I needed to force to reference category to
                % 'N/A' as otherwise half of the time the algorithm uses
                % N/A and half the time BH. Welcome to hardcoding.
            else
                categories_indep = swapMostFrequentCategory(eval(variableName), categories_indep);
            end
        end
        eval([variableName, ' = categorical(', variableName, ', categories_indep);']);


    end


    % Initialize formula string and data table
    formulaStr = 'dependentVar ~ ';
    dataVariables = {'dependentVar'};

    for i = 1:numIndependentVars
        variableName = ['independentVar', num2str(i)];
        formulaStr = [formulaStr, variableName, ' + '];
        dataVariables{end + 1} = variableName;
    end

    % Remove the trailing '+'
    formulaStr = formulaStr(1:end-2);


    % Create the data table
    data = table(dependentVar);

    for i = 2:numIndependentVars+1
        variableName = dataVariables{i};
        data.(variableName) = eval(dataVariables{i});
    end


    mdl = fitglm(data, formulaStr, 'Distribution', 'binomial', 'Link', 'logit');


    % Display summary of the logistic regression model
    if flag_display
        disp(mdl);
    end


    % Make predictions using the model
    predictions = predict(mdl, data);

    % extract pvalues
    mdlc = mdl.Coefficients;
    if flag_display_pvalue  % under "if" because for some independent variables, the number of categories for given H does not contain the full set of categories
        Pvalues(m,:) = mdlc(2:end,4).Variables;
    end
    m = m+1;
end


%% display number of sign pvalues per category
if flag_display_pvalue
    % Get the coefficient names
    coefNames = mdl.CoefficientNames;

    % Exclude intercept
    independentVarNames = coefNames(2:end);

    % Display independent variable names, t-values, and p-values
    disp('Independent Variable | Frequency of Significance');
    disp('-----------------------------------------');
    for i = 1:numel(independentVarNames)
        fprintf('%s | %d\n', independentVarNames{i}, size(find(Pvalues(:,i)<p_threshold)));
    end
end


if flag_chi2_test
    % Number of independent variables
    numIndepVars = numel(independentColsIndices);

    fprintf('\n\n'); % Add two blank lines
    disp('-------CHI-SQUARE TEST RESULTS--------');

    % Iterate through all combinations of independent variables
    for i = 1:numIndepVars
        for j = i+1:numIndepVars
            % Extract independent variables
            independentVar1 = table2cell(dummy(:, independentColsIndices(i)));
            independentVar2 = table2cell(dummy(:, independentColsIndices(j)));

            % Create contingency table
            contingencyTable = crosstab(independentVar1, independentVar2);

            % Perform chi-square test
            [pval, chi2stat] = chi2test(contingencyTable);

            % Display results
            disp(['Chi2-statistic for ', num2str(i), ' vs ', num2str(j), ': ', num2str(chi2stat)]);
            disp(['p-value for ', num2str(i), ' vs ', num2str(j), ': ', num2str(pval)]);
            disp('-----------------------------------------');
        end
    end
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