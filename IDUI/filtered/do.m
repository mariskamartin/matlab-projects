clc;

% scaleSampleIndexes = 1:3:1000;
scaleSampleIndexes = 1:1:length(data.signals.values);
% scaleSampleIndexes = 1:1:500;

u=data.signals.values(scaleSampleIndexes,1)';
y=data.signals.values(scaleSampleIndexes,2)';
t=1:length(u); %t,u,y .. radkove vektory

%creates inputs
inputs = [y(3:end); y(2:end-1); y(1:end-2); u(1:end-2)];
%creates targets
targets = u(2:end-1);


% y(k+1) = f[y(k), u(k)]
% u(k) = f[y(k+1), y(k)]
% %creates inputs
% inputs = [y(2:end); y(1:end-1)];
% %creates targets
% targets = u(1:end-1);
