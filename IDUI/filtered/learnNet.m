function [net, trainResults] = learnNet(inputs, targets, topology, maxTrainTime)
% povinne jsou prvni dva argumenty "inputs, targets"

clear('net');
net = fitnet(topology);
% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;
% nezobrazovat okno uceni
net.trainParam.showWindow = false;

net.trainParam.time = maxTrainTime;
net.trainParam.epochs = 1000;
net.trainParam.max_fail = 100;

% Train the Network
[net, trainResults] = train(net, inputs, targets);
