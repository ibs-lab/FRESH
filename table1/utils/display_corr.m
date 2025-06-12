function stats = display_corr(num)
    % Extract relevant columns
    a_conf = num(:, 126); % Analysis confidence
    r_conf = num(:, 127); % Results confidence
    e_conf = num(:, 149); % Education confidence

    % Helper function to calculate 95% confidence intervals for correlation
    function [ci_lower, ci_upper] = compute_corr_ci(r, n)
        z = 0.5 * log((1 + r) / (1 - r)); % Fisher's Z transformation
        se = 1 / sqrt(n - 3);             % Standard error
        z_crit = 1.96;                    % Critical value for 95% CI
        z_lower = z - z_crit * se;        % Lower bound in Z-space
        z_upper = z + z_crit * se;        % Upper bound in Z-space
        ci_lower = (exp(2 * z_lower) - 1) / (exp(2 * z_lower) + 1); % Transform back to r-space
        ci_upper = (exp(2 * z_upper) - 1) / (exp(2 * z_upper) + 1); % Transform back to r-space
    end

    % Initialize a structure to store all statistics
    stats = struct();

    % Compute correlations
    % 1. Correlation between a_conf and e_conf
    [r_ae, p_ae] = corr(a_conf, e_conf, 'rows', 'complete');
    n_ae = sum(~any(isnan([a_conf, e_conf]), 2)); % Sample size for this correlation
    [ci_lower_ae, ci_upper_ae] = compute_corr_ci(r_ae, n_ae); % 95% CI
    stats.analysis_vs_education = struct('r', r_ae, 'p', p_ae, 'n', n_ae, 'ci', [ci_lower_ae, ci_upper_ae]);
    disp(['Correlation between analysis confidence and education: r = ', num2str(r_ae, '%.2f'), ...
          ', p < ', num2str(max(p_ae, 1e-3), '%.3f'), ', 95% CI [', ...
          num2str(ci_lower_ae, '%.2f'), ', ', num2str(ci_upper_ae, '%.2f'), '], n = ', num2str(n_ae)]);

    % 2. Correlation between r_conf and e_conf
    [r_re, p_re] = corr(r_conf, e_conf, 'rows', 'complete');
    n_re = sum(~any(isnan([r_conf, e_conf]), 2)); % Sample size for this correlation
    [ci_lower_re, ci_upper_re] = compute_corr_ci(r_re, n_re); % 95% CI
    stats.results_vs_education = struct('r', r_re, 'p', p_re, 'n', n_re, 'ci', [ci_lower_re, ci_upper_re]);
    disp(['Correlation between results confidence and education: r = ', num2str(r_re, '%.2f'), ...
          ', p < ', num2str(max(p_re, 1e-3), '%.3f'), ', 95% CI [', ...
          num2str(ci_lower_re, '%.2f'), ', ', num2str(ci_upper_re, '%.2f'), '], n = ', num2str(n_re)]);

    % 3. Correlation between a_conf and r_conf
    [r_ar, p_ar] = corr(a_conf, r_conf, 'rows', 'complete');
    n_ar = sum(~any(isnan([a_conf, r_conf]), 2)); % Sample size for this correlation
    [ci_lower_ar, ci_upper_ar] = compute_corr_ci(r_ar, n_ar); % 95% CI
    stats.analysis_vs_results = struct('r', r_ar, 'p', p_ar, 'n', n_ar, 'ci', [ci_lower_ar, ci_upper_ar]);
    disp(['Correlation between analysis confidence and results confidence: r = ', num2str(r_ar, '%.2f'), ...
          ', p < ', num2str(max(p_ar, 1e-3), '%.3f'), ', 95% CI [', ...
          num2str(ci_lower_ar, '%.2f'), ', ', num2str(ci_upper_ar, '%.2f'), '], n = ', num2str(n_ar)]);

    % Displaying Statistics Summary (Optional)
    disp('Summary of all correlation statistics:');
    disp(stats);
end