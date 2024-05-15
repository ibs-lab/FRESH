function [H_STUDY_I, H_STUDY_II] = hypothesis_variability(txt)
% INPUT
% txt: txt read from freshdata.csv (see main_fresh.m)
% MAY

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
    a = 0; b = 0; c = 0; m = 1;
end

% STUDY 2 %%%%%%%%%%%%%%%%%%%%%%

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

    % reset
    a = 0; b = 0; c = 0; m = 1;
end

