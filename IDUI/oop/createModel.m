load data;
clear('tout','v'); % jsem omylem ulozil do data.mat

trimCount = 14000; %omezeni dat
t=data.signals.values(1:trimCount,1)'; %t,u,y .. radkove vektory
u=data.signals.values(1:trimCount,2)';
y=data.signals.values(1:trimCount,3)';

%creates inputs
inputs = [y(2:end-1); y(1:end-2); u(2:end-1); u(1:end-2)];
%creates targets
targets = y(3:end);

%objekt modelu motoru
dnnModel = DnnModel();
% dnnModel.learn(inputs, targets);
dnnModel.learnOptimized(inputs, targets);
dnnModel.showRegression();

%uklidit
clear('t','u','y','trimCount');