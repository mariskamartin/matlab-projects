% skript for DIC direct inverse control method
% creation of inverse system model

load data;

trimCount = 10000; %omezeni dat %14000
t=data.signals.values(1:trimCount,1)'; %t,u,y .. radkove vektory
u=data.signals.values(1:trimCount,2)';
y=data.signals.values(1:trimCount,3)';

%special ordering of input values specific for DIC
%creates inputs
inputs = [y(3:end); y(2:end-1); y(1:end-2); u(1:end-2)];
%creates targets
targets = u(2:end-1);

%objekt modelu motoru
dnnModel = DnnModel();
% dnnModel.learn(inputs, targets);
dnnModel.learnOptimized(inputs, targets);
dnnModel.showRegression();

%uklidit
clear('t','u','y','trimCount');