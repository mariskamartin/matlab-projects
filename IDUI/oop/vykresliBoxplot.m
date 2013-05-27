% boxData = zeros(length(pomFileVariable)/5,5);
% for k = 1:length(pomFileVariable)/5
%     idxs = 1:5;
%     subMat = idxs .* k;
%     boxData(k,:) = pomFileVariable(subMat,2)';
% end
boxplot(pomFileVariable(:,2), pomFileVariable(:,1));