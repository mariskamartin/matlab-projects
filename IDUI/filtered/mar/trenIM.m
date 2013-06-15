function [net] = trenIM(data, pocetNeuronu)
u = data(:,2)';
y = data(:,3)';
vstup = [y(2:end); y(1:end-1)];
vystup = u(1:end-1);
net = newff(vstup,vystup,[pocetNeuronu],{'tansig','tansig'});
[net, tr] = train(net, vstup, vystup);