u=data.signals.values(:,1)';
y=data.signals.values(:,2)';
inputs = [y(2:end); y(1:end-1)];
%creates targets
targets = u(1:end-1);