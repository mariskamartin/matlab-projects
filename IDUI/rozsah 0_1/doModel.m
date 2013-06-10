% u=data.signals.values(:,1)';
% y=data.signals.values(:,2)';
% inputs = [y(2:end); y(1:end-1)];
% %creates targets
% targets = u(1:end-1);

clc;

u=data.signals.values(:,1)';
y=data.signals.values(:,2)';
t=1:length(u); %t,u,y .. radkove vektory

%special ordering of input values specific for DIC
%creates inputs
inputs = [y(2:end-1); y(1:end-2); u(2:end-1); u(1:end-2)];
%creates targets
targets = y(3:end);