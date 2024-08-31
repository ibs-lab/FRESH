function fig_analysis_vs_results_conf(num, cmap)
% analysis confidence vs results confidence
% INPUT
% num: Numerical output read from freshdata.csv

% Get rid of NaNs
a_conf = num(:,126); ind = ~isnan(a_conf); a_conf = a_conf(ind);
r_conf = num(:,127); ind = ~isnan(r_conf); r_conf = r_conf(ind);
total_defaults = sum(num(:,154:159),2); total_defaults = total_defaults(ind);

x = [a_conf'; r_conf']';

% Get number of repetitions of the same pair of points (e.g. 5 and 5)
for i = 1:5
    for j = 1:5
        I(i,j) = sum(x(:, 1) == i & x(:, 2) == j);
    end
end

% Create a size vector for scatter plot, size being the number of repetitions
sz = [];
for i = 1:size(x,1)
    sz = [sz I(x(i,1),x(i,2))];
end

figure;

% Fit the linear model and compute the confidence intervals
[P, S] = polyfit(a_conf, r_conf, 1); % Linear fit (1st degree)
yfit = polyval(P, a_conf);           % Fitted values
[Yfit_CI, delta] = polyconf(P, a_conf, S, 'alpha', 0.05); % 95% confidence interval

% Plot the confidence intervals first
fill([a_conf; flipud(a_conf)], [Yfit_CI + delta; flipud(Yfit_CI - delta)], ...
    [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5); % Shaded area for CI
hold on;

% Plot the regression line
plot(a_conf, yfit, '-', 'LineWidth', 3, 'Color', cmap(40,:));

% Plot the confidence interval boundaries
plot(a_conf, Yfit_CI + delta, 'k--', 'LineWidth', 1.5); % Upper confidence bounds
plot(a_conf, Yfit_CI - delta, 'k--', 'LineWidth', 1.5); % Lower confidence bounds

% Plot the scatter plot on top
scatter(a_conf, r_conf, sz * 30, 'ok', 'MarkerFaceColor', cmap(40,:)); 

% Correlation and p-value calculation
[RHO, PVAL] = corr(a_conf, r_conf);
disp('Correlation Coefficient (RHO) for Analysis Confidence vs Results Confidence:');
disp(RHO);
disp('P-Value (PVAL):');
disp(PVAL);

% Set axis labels and limits
xlabel('Analysis Confidence');
ylabel('Results Confidence');
xticks(0:5); % Set the x-axis ticks to integer values
yticks(0:5);
xlim([0.5 5.5]);
ylim([0.5 5.5]);

% Title with correlation and p-value
title(['r: ' num2str(round(RHO,2),2), ', p = ' num2str(PVAL, '%.2e')]);

% Correlation between confidence and total number of defaults
[rho, p] = corr(a_conf, total_defaults);
disp('Correlation Coefficient (RHO) for Analysis Confidence vs Total Number of Default Use:');
disp(rho);
disp('P-Value (PVAL):');
disp(p);

[rho, p] = corr(r_conf, total_defaults);
disp('Correlation Coefficient (RHO) for Results Confidence vs Total Number of Default Use:');
disp(rho);
disp('P-Value (PVAL):');
disp(p);
end
