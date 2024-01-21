function display_corr(num)

a_conf = num(:,126); 
r_conf = num(:,127); 
e_conf = num(:,149);

% Correlation between a_conf and e_conf
[r_ae, p_ae] = corr(a_conf, e_conf, 'rows', 'complete');
disp(['Correlation between analysis confidence and education: r = ', num2str(r_ae), ', p = ', num2str(p_ae)]);

% Correlation between r_conf and e_conf
[r_re, p_re] = corr(r_conf, e_conf, 'rows', 'complete');
disp(['Correlation between results confidence and education: r = ', num2str(r_re), ', p = ', num2str(p_re)]);

% Correlation between a_conf and r_conf
[r_ar, p_ar] = corr(a_conf, r_conf, 'rows', 'complete');
disp(['Correlation between analysis confidence and results confidence: r = ', num2str(r_ar), ', p = ', num2str(p_ar)]);
