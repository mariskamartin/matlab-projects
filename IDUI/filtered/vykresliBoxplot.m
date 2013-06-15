% boxData = zeros(length(pomFileVariable)/5,5);
% for k = 1:length(pomFileVariable)/5
%     idxs = 1:5;
%     subMat = idxs .* k;
%     boxData(k,:) = pomFileVariable(subMat,2)';
% end
function vykresliBoxplot(pomFileVariable)
    if(iscellstr(pomFileVariable(:,1)))
        %pro cell array
        data = cell2mat(pomFileVariable(:,3));
        groups = char(pomFileVariable(:,1));
    else
        %pro ostatni
        data = pomFileVariable(:,3);
        groups = pomFileVariable(:,1);
    end
    boxplot(data, groups);
