%
% Simulace soustavy druheho radu.
% estimace stavu (adaptivni kalman)
%
clear all;
Ts = 0.1; %time stamp / vzorkovaci perioda
numOfValues = 500; %number of values in one step 
%vytvoreni systemu 2. radu
sysTF = tf([1 1],[5 1 1]); D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model
radSoustavy = length(B);

u = ones(1,numOfValues*4); %input data for step
w = [0.2*ones(1,numOfValues) 1*ones(1,numOfValues) 0.5*ones(1,numOfValues) 0*ones(1,numOfValues)]; %reference variable
t = 0:Ts:length(u)*Ts; %time data
x = zeros(radSoustavy, 1); %initial state - vertical
yMnc = zeros(1,3); %start rekonstrukce pomoci mnc

%inicializace
for k=1:length(u)
  y(k) = C*x + D*u(k) +randn()*0.0001; %out with measurement noise
  % time update
  u(k) = w(k);
  x = A*x + B*u(k);
end

%identifikace parametru pomoci MNC
[A, B]=MNC(y(3:end),u(3:end),radSoustavy,radSoustavy);
for k=(radSoustavy+1):length(u)
    yMnc(k) = B*u(k-1:-1:k-radSoustavy)'-A*yMnc(k-1:-1:k-radSoustavy)';
%     yMnc(k) =B(1)*u(k-1)+B(2)*u(k-2)-A(1)*yMnc(k-1)-A(2)*yMnc(k-2);
end


clf;
hold on; 
stairs(t(1:end-1),u,'-b');
plot(t(1:end-1),y,'-r');
plot(t(1:end-1), yMnc, 'k');
legend('u','y','mnc');


