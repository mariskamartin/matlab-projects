clc;

part = length(data.signals.values) / 8;
scaleSampleIndexes = fix(part*4):3:part*5;
% scaleSampleIndexes = 1:1:length(data.signals.values);
sampleTime = 0.75; %of second

u=data.signals.values(scaleSampleIndexes,1)';
y=data.signals.values(scaleSampleIndexes,2)';
t=1:length(u); %t,u,y .. radkove vektory

%special ordering of input values specific for DIC
%creates inputs
inputs = [y(2:end-1); y(1:end-2); u(2:end-1); u(1:end-2)];
%creates targets
targets = y(3:end);