%
% Simulace prechodu obycejne soustavy pseudo druheho radu.
% bez regulatoru, ciste reakce na vstupni signal u
%

clear all;
Ts = 0.1; %time stamp / vzorkovaci perioda
%vytvoreni systemu
sysTF = tf([1 1],[1 1 1]); 

D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model

u = [ones(1,140) 2*ones(1,140)]; %input data
T = 0:Ts:length(u)*Ts; %time data
x = [0; 0]; %initial state - vertical

y = zeros(1,length(u));
for k = 1:length(u)
    y(k)= C*x + D*u(k);
    x = A*x + B*u(k);
end

stairs(T(1:end-1),u,'-b');
hold on; 
stairs(T(1:end-1),y,'-r');
legend('u','y');
hold off;

