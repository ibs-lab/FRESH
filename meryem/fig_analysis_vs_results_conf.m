function fig_analysis_vs_results_conf(num)
% analysis confidence vs results confidence
% INPUT
% num: Numerical output read from freshdata.csv

% get rid of NaNs
a_conf = num(:,126); ind = ~isnan(a_conf); a_conf=a_conf(ind);
r_conf = num(:,127); ind = ~isnan(r_conf); r_conf=r_conf(ind);

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


figure;scatter(a_conf,r_conf,sz*25,'ok', 'MarkerFaceColor','k'); hold;
xlabel('Analysis Confidence');
ylabel('Results Confidence');
xticks(2:5); % Set the x-axis ticks to integer values
yticks(2:5);



P = polyfit(a_conf,r_conf,1); yfit = polyval(P,a_conf);
[RHO,PVAL] = corr(a_conf,r_conf);
h0 = plot(a_conf,yfit,'k-','LineWidth',3);

title(['corr: ' num2str(round(RHO,2),2), ', p: ' num2str(round(PVAL,2),2)]);
