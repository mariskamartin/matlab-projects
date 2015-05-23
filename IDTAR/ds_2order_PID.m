%
% Simulace soustavy druheho radu.
% s PI regulatorem
%

clear all;
Ts = 0.1; %time stamp / vzorkovaci perioda
numOfValues = 300; %number of values in one step 
%vytvoreni systemu 2. radu
sysTF = tf(1,[1 1 1]); 

D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model

u = ones(1,numOfValues*3); %input data for step
w = [ones(1,numOfValues) 2*ones(1,numOfValues) 2.6*ones(1,numOfValues)]; %reference variable
T = 0:Ts:length(u)*Ts; %time data
x = [0; 0]; %initial state - vertical

% inicializace regulatoru
P = 2; I = 1; D = 0; %PI regulator
reg = PIDreg(P,I,D,Ts);

% simulace
y = zeros(1,length(u));
for k = 1:length(u)
    y(k)= C*x + D*u(k);
    u(k) = reg.evalControlAction(w(k), y(k));
    x = A*x + B*u(k);
end

stairs(T(1:end-1),w,'-b');
hold on; 
stairs(T(1:end-1),y,'-r');
stairs(T(1:end-1),u,':k');
legend('w','y','u')
hold off; 

