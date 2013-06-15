clc;

% % scaleSampleIndexes = 1:3:3*400;
% scaleSampleIndexes = 1:1:length(data.signals.values);
% % scaleSampleIndexes = 1:1:500;
% 
u=data(:,2)';
y=data(:,3)';
t=1:length(u); %t,u,y .. radkove vektory


% y(k+1) = f[y(k), u(k)]
% u(k) = f[y(k+1), y(k)]
%creates inputs
inputs = [y(2:end); y(1:end-1)];
%creates targets
targets = u(1:end-1);
