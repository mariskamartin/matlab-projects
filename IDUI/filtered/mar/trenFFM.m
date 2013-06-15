function [net] = trenFFM(data, pocetNeuronu)
u = data(:,2)';
y = data(:,3)';
vstup = [u(1:end-2);u(2:end-1);y(1:end-2);y(2:end-1);];
vystup = y(3:end);
net = newff(vstup,vystup,[pocetNeuronu],{'tansig','tansig'});
[net, tr] = train(net, vstup, vystup);