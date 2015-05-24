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
R=0.00001;  % Covariation Matrix for process Uncertainty %male cislo, protoze nemame na vstupu chybu
Q=1; %Covariation Matrix for output Uncertainty
kalEstimator = KalmanEstimator(A,B,C,D,Q,R, [0;0]);

% nalezeni kal. zesileni
% [Kd,S,e] = dlqr(A',C',Q, R); %na nekonecnem horizontu.. tedy staci spocitat jen jednou
% Kd = Kd';

for k=1:length(u)
  yv(k) = C*x + D*u(k) + (randn()*0.03); %out with measurement noise
  % estimation
  [ye(k), xEst] = kalEstimator.setPlant(A,B,C,D).estimate(u(k), yv(k));
  % time update
  u(k) = w(k);
  x = A*x + B*u(k);
end

clf;
stairs(t(1:end-1),w,'-m');
hold on; 
plot(t(1:end-1),yv,'-r');
plot(t(1:end-1),ye,'-k');
legend('w','y','y est.');


