%
% Simulace soustavy druheho radu.
% estimace stavu (kalman)
% 
% http://www.mathworks.com/help/control/ug/kalman-filtering.html#zmw57dd0e24572
%

clear all;
Ts = 0.01; %time stamp / vzorkovaci perioda
numOfValues = 1000; %number of values in one step 
%vytvoreni systemu 2. radu
sysTF = tf(1,[1 1 1]); D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model
Nx = size(A,1); %number of states
Nu = size(B,2); %number of inputs

u = ones(1,numOfValues*3); %input data for step
w = [0*ones(1,numOfValues) 1*ones(1,numOfValues) 0.5*ones(1,numOfValues)]; %reference variable
T = 0:Ts:length(u)*Ts; %time data
xOrig = [0; 0]; %initial state - vertical

%inicializace
R=0.00001;  % Covariation Matrix for process Uncertainty %male cislo, protoze nemame na vstupu chybu
Q=1; %Covariation Matrix for output Uncertainty
P = B*Q*B';         % Initial error covariance
y = zeros(1,length(u));
x = zeros(Nx,1);     % Initial condition on the state
ye = zeros(length(u),1);

% % nalezeni K zesileni
% [Kd,S,e] = dlqr(A',C',Q, R); %na nekonecnem horizontu.. tedy staci spocitat jen jednou
% Kd = Kd';

for k=1:length(u)
  yv(k) = C*xOrig + D*u(k) + (randn()*0.03); %out with measurement noise
  
  % Measurement update
  L = (P*C')/(C*P*C'+R);     %kalman gain
  x = x + L*(yv(k)-C*x);   % x[n|n]
  P = (eye(Nx)-L*C)*P;     % P[n|n]

  ye(k) = C*x;
%   errcov(k) = C*P*C';

  % Time update
  x = A*x + B*u(k);        % x[n+1|n]
  P = A*P*A' + B*Q*B';     % P[n+1|n]

  u(k) = w(k);
  xOrig = A*xOrig + B*u(k);        % x[n+1|n]
  
  %history
  xOrigH(:,k) = xOrig;
  xH(:,k) = x;
end

clf;
stairs(T(1:end-1),w,'-m');
hold on; 
plot(T(1:end-1),yv,'-r');
plot(T(1:end-1),ye,'-k');
legend('w','y','y est.');

% plot(T(1:end-1),xH');
% plot(T(1:end-1),xOrigH');


