%
% Simulace soustavy druheho radu.
% estimace stavu (kalman)
%

clear all;
Ts = 0.1; %time stamp / vzorkovaci perioda
numOfValues = 300; %number of values in one step 
%vytvoreni systemu 2. radu
sysTF = tf(1,[1 1 1]); 

D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model
Nx = size(A,1);
Nu = size(B,2);

u = ones(1,numOfValues*3); %input data for step
w = [ones(1,numOfValues) 2*ones(1,numOfValues) 2.6*ones(1,numOfValues)]; %reference variable
T = 0:Ts:length(u)*Ts; %time data
x = [0; 0]; %initial state - vertical

%inicializace regulatoru
Qn = 1*eye(Nx);    % matice penalizaci koncoveho stavu
R = 1*eye(Nu);   % matice penalizaci akcnich zasahu
Q = 100;          % matice penalizaci regulacnich odchylek
Nn=20; %Horizont rizeni

% simulace
y = zeros(1,length(u));
xH = zeros(2,length(u));
xKalH = zeros(2,length(u));
xEstH = zeros(2,length(u));
xEst = [0;0];

[Kd,S,e] = dlqr(A',C',Qn,R); %na nekonecnem horizontu.. tedy staci spocitat jen jednou
Kd = Kd';
% *** Inicializace pro Kalmanuv filtr
xkal=zeros(length(A),1); 
Ge=eye(2,1)*1; 
Qkal=1; %..presnost 
Rkal=1; %..akce
Pkal=0;

for k = 1:length(u)-Nn
    sum = randn()*0.01;
    y(k) = C*x + D*u(k) + sum;
    yKal = C*xkal + D*u(k) + sum;

    % estimace - na nekonecnem horizontu
    xEst = (A - Kd*C) * xEst + B*u(k) + Kd*y(k);
    % adaptivni kalman
    [xkal, Pkal]=adaptKalmanEstim(A, B, C, D, Ge, Qkal, Rkal, xkal, (y(k)-yKal), u(k), Pkal);       %Kalmanuv filtr

    u(k)= w(k);
    x = A*x + B*u(k);
    
    xH(:, k) = x;
    xEstH(:, k) = xEst;
    xKalH(:, k) = xkal;
end

clf;
stairs(T(1:end-1),w,'-b');
hold on; 
stairs(T(1:end-1),y,'-r');
% stairs(T(1:end-1),u,':k');
% legend('w','y','u');
% hold off;
% figure;
stairs(T(1:end-1),xH');
stairs(T(1:end-1),xKalH','k');
stairs(T(1:end-1),xEstH','r');
legend('w','y','x1','x2','xk1','xk2','xEs1','xEs2');


