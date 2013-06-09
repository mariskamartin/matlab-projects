% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by NFTOOL
% Created Mon May 27 20:20:07 CEST 2013
%
% This script assumes these variables are defined:
%
%   inputs - input data.
%   targets - target data.
load data;

trimCount = 5000; %omezeni dat
t=data.signals.values(1:trimCount,1)'; %t,u,y .. radkove vektory
u=data.signals.values(1:trimCount,2)';
y=data.signals.values(1:trimCount,3)';

%special ordering of input values specific for DIC
%creates inputs
inputs = [y(3:end); y(2:end-1); y(1:end-2); u(1:end-2)];
%creates targets
targets = u(2:end-1);

% Create a Fitting Network
hiddenLayerSize = [30];
net = fitnet(hiddenLayerSize);


% Setup Identation Division of Data for Training, Validation, Testing
net.divideFcn = 'divideind';
net.divideParam.trainInd=1:(trimCount-1000);
net.divideParam.valInd=(trimCount-999):(trimCount-500);    
net.divideParam.testInd=(trimCount-499):trimCount; 

% net.divideParam.trainRatio = 80/100;
% net.divideParam.valRatio = 10/100;
% net.divideParam.testRatio = 10/100;

net.trainParam.max_fail = 1000;


% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotfit(net,inputs,targets)
%figure, plotregression(targets,outputs)
%figure, ploterrhist(errors)