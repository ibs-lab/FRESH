function [H_STUDY_I, H_STUDY_II] = fig_hypothesis_variability(txt)
% INPUT
% txt: txt read from freshdata.csv (see main_fresh.m)
% MAY

figure;
a = 0; b = 0; c = 0; m = 1;
for j = 3:3:21 % across hypotheses
    for i = 2:2:size(txt,1) % across groups
        if strcmp(txt{i,j},'Yes')
            a = a + 1;
            H_STUDY_I(j/3,m) = 1;
        elseif strcmp(txt{i,j},'No')
            b = b + 1;
            H_STUDY_I(j/3,m) = 2;
        else % not intestigated
            c = c + 1;
            H_STUDY_I(j/3,m) = 3;
        end
        m = m+1;
    end
    a_all(j/3) = a; % total number of groups that said Y to each hypothesis (each column is a separate hypothesis)
    b_all(j/3) = b; % total number of groups that said N to each hypothesis (each column is a separate hypothesis)
    c_all(j/3) = c;

    subplot(1,7,j/3);
    p = pie([a;b;c]);
    h = title(txt(1,j));
    h.Position = h.Position + [0 0.2 0];

    pText = findobj(p,'Type','text');
    percentValues = get(pText,'String');
    %     labels = {'YES','NO','NOT INV.'};
    labels = {'Yes ';'No ';'Not Investigated'};

    ax = gca();
    newColors = [0 1 0; 0 0 1; 0 0 0];
    ax.Colormap = newColors;
    a = 0; b = 0; c = 0; m = 1;
end
% Create legend
legend(labels);

figure; plot(a_all./(a_all+b_all),'.','MarkerFaceColor','b','MarkerSize', 35); ylim([0 1]);
xlabel('Hypotheses'); xlim([0.9 7.1]);
title('Fraction of groups reporting a significant result')


% STUDY 2 %%%%%%%%%%%%%%%%%%%%%%

figure;
a = 0; b = 0; c = 0; n =1;
a_all = []; b_all = []; c_all = [];
for j = 24:1:63
    for i = 3:2:size(txt,1)
        if strcmp(txt{i,j},'Yes')
            a = a + 1;
            H_STUDY_II(j-23,m) = 1;
        elseif strcmp(txt{i,j},'No')
            b = b + 1;
            H_STUDY_II(j-23,m) = 2;
        else
            c = c + 1;
            H_STUDY_II(j-23,m) = 3;
        end
        m = m+1;
    end
    a_all = [a_all a];
    b_all = [b_all b];
    c_all = [c_all c];



    subplot(4,10,n);
    p = pie([a;b;c]);

    % column headings
    if j<34
        dummy = txt(1,j);
        dummy = dummy{1}(end-13:end);
        h = title(dummy);
        h.Position = h.Position + [0 0.2 0];
    end

    % % row headings - ylabel/pie/subplot combination doesn't work for some
    % % holy reason. Reported to Mathworks - MAY
    % % if j==24
    % %     dummy = txt(1,j);
    % %     dummy = dummy{1}(8:19);
    % %     ylabel(dummy);
    % % end


    % Manually position text on the y-axis
    if j == 24 || j == 34 || j == 44 || j == 54
        dummy = txt(1,j);
        dummy = dummy{1}(8:20);
        text(-3, mean(ylim), dummy, 'Rotation', 90, 'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold');
    end


    % add percentage text
    pText = findobj(p,'Type','text');
    percentValues = get(pText,'String');
    labels = {'Yes ';'No ';'Not Investigated'};
    n = n+1;

    % chance colors
    ax = gca;
    ax.Colormap = newColors;

    % reset
    a = 0; b = 0; c = 0; m = 1;
end
% Create legend
% legend(labels);


% figure; plot(a_all./(a_all+b_all),'mo','MarkerFaceColor','m'); ylim([0 1]);
t = a_all./(a_all+b_all);
tt = reshape(t, 10, 4);
figure;plot(tt','.','MarkerFaceColor','k','MarkerSize', 35);ylim([0 1]);
xlabel('Hypotheses'); xlim([0.9 4.1]); xticks(1:4); % Set the x-axis ticks to integer values
title('Fraction of groups reporting a significant result')
