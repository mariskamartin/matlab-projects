%
% Simulace soustavy druheho radu.
% estimace stavu (adaptivni kalman)
%
clear all;
Ts = 0.01; %time stamp / vzorkovaci perioda
numOfValues = 1000; %number of values in one step 
%vytvoreni systemu 2. radu
sysTF = tf(1,[1 1 1]); D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model

u = ones(1,numOfValues*3); %input data for step
w = [0*ones(1,numOfValues) 1*ones(1,numOfValues) 0.5*ones(1,numOfValues)]; %reference variable
t = 0:Ts:length(u)*Ts; %time data
x = [0; 0]; %initial state - vertical

%inicializace
for k=1:length(u)
  y(k) = C*x + D*u(k); %out with measurement noise
  % time update
  u(k) = w(k);
  x = A*x + B*u(k);
end

[A, B]=MNC(y(10:end),u(10:end),2,2);
v = mnc2(w, y, ones(1,length(u)),4);

gy = polyval(v,w);

clf;
hold on; 
plot(t(1:end-1), gy, 'k');
stairs(t(1:end-1),w,'-m');
plot(t(1:end-1),y,'-r');
legend('mnc','w','y');


