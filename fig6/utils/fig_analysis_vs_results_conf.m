function fig_analysis_vs_results_conf(num, cmap)
% analysis confidence vs results confidence
% INPUT
% num: Numerical output read from freshdata.csv

% get rid of NaNs
a_conf = num(:,126); ind = ~isnan(a_conf); a_conf=a_conf(ind);
r_conf = num(:,127); ind = ~isnan(r_conf); r_conf=r_conf(ind);
total_defaults = sum(num(:,154:159),2); total_defaults = total_defaults(ind);

x = [a_conf'; r_conf']';

% get number of repetition of the same two pair of points (e.g. 5 and 5)
for i = 1:5
    for j = 1:5
        I(i,j) = sum(x(:, 1) == i & x(:, 2) == j);
    end
end

% create a size vector for scatter plot, size being the number of
% repetitions
sz = [];
for i = 1:size(x,1)
    sz = [sz I(x(i,1),x(i,2))] ;
end


figure;

P = polyfit(a_conf,r_conf,1); yfit = polyval(P,a_conf);
[RHO,PVAL] = corr(a_conf,r_conf);
% Display the results
disp('Correlation Coefficient (RHO) for Analysis Confidence vs Results Confidence:');
disp(RHO);
disp('P-Value (PVAL):');
disp(PVAL);
h0 = plot(a_conf,yfit,'-','LineWidth', 3, 'color',cmap(40,:));
hold on;
scatter(a_conf,r_conf,sz*30,'ok', 'MarkerFaceColor', cmap(40,:)); hold;
xlabel('Analysis Confidence');
ylabel('Results Confidence');
xticks(0:5); % Set the x-axis ticks to integer values
yticks(0:5);
xlim([0 5]);
ylim([0 5]);

title(['r: ' num2str(round(RHO,2),2), ', p: ' num2str(round(PVAL,2),2)]);

% corr between confidence and total number of default use
[rho, p] = corr(a_conf,total_defaults);
disp('Correlation Coefficient (RHO) for Analysis Confidence vs Total Number of Default Use:');
disp(rho);
disp('P-Value (PVAL):');
disp(p);

[rho, p] = corr(r_conf,total_defaults);
disp('Correlation Coefficient (RHO) for Results Confidence vs Total Number of Default Use:');
disp(rho);
disp('P-Value (PVAL):');
disp(p);
