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

% Create a size vector for scatter plot
sz = arrayfun(@(i) I(x(i,1),x(i,2)), 1:size(x,1));

figure;

% Fit the linear model and compute the confidence intervals
[P, S] = polyfit(a_conf, r_conf, 1); % Linear fit (1st degree)
yfit = polyval(P, a_conf);           % Fitted values
[Yfit_CI, delta] = polyconf(P, a_conf, S, 'alpha', 0.05); % 95% confidence interval

% Plot confidence intervals
fill([a_conf; flipud(a_conf)], [Yfit_CI + delta; flipud(Yfit_CI - delta)], ...
    [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5); % Shaded area for CI
hold on;

% Regression line
plot(a_conf, yfit, '-', 'LineWidth', 3, 'Color', cmap(40,:));

% Confidence bounds
plot(a_conf, Yfit_CI + delta, 'k--', 'LineWidth', 1.5); 
plot(a_conf, Yfit_CI - delta, 'k--', 'LineWidth', 1.5);

% Scatter plot
scatter(a_conf, r_conf, sz * 30, 'ok', 'MarkerFaceColor', cmap(40,:)); 

% Compute Pearson correlation and p-value
[RHO, PVAL] = corr(a_conf, r_conf);
n = length(a_conf);

% Compute 95% CI for Pearson r using Fisher z-transform
z = 0.5 * log((1 + RHO) / (1 - RHO));
se = 1 / sqrt(n - 3);
z_crit = norminv(0.975);  % 1.96
z_CI = [z - z_crit * se, z + z_crit * se];
r_CI = (exp(2 * z_CI) - 1) ./ (exp(2 * z_CI) + 1);

% Display in command window
fprintf('\nPearson correlation between analysis and results confidence:\n');
fprintf('r = %.2f, p = %.4f, 95%% CI [%.2f, %.2f], n = %d\n', RHO, PVAL, r_CI(1), r_CI(2), n);

% Set axis
xlabel('Analysis Confidence');
ylabel('Results Confidence');
xticks(0:5); yticks(0:5);
xlim([0.5 5.5]); ylim([0.5 5.5]);

% Title
title(sprintf('r = %.2f, p = %.2e', RHO, PVAL));

% Additional analysis: confidence vs default use
[rho_a, p_a] = corr(a_conf, total_defaults);
[rho_r, p_r] = corr(r_conf, total_defaults);

fprintf('\nCorrelation with total default usage:\n');
fprintf('Analysis Confidence: r = %.2f, p = %.4f\n', rho_a, p_a);
fprintf('Results Confidence:  r = %.2f, p = %.4f\n', rho_r, p_r);
end
