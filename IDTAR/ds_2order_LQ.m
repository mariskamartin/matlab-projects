%
% Simulace soustavy druheho radu.
% s LQ regulatorem, ktery ridi na danem horizontu
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

w = [ones(1,numOfValues) 2*ones(1,numOfValues) 2.6*ones(1,numOfValues)]; %reference variable
u = zeros(size(w)); %input data for step
T = 0:Ts:length(w)*Ts; %time data
x = [0; 0]; %initial state - vertical

%inicializace regulatoru
% Qn = 0*eye(Nx);    % matice penalizaci koncoveho stavu
R = 0.01;   % matice penalizaci akcnich zasahu
Q = 1;          % matice penalizaci regulacnich odchylek
Nn=10; %Horizont rizeni

% *** Inicializace pro Kalmanuv filtr
xkal=zeros(length(A),1); Ge=eye(2,1)*1000; Pkal=0;
Qkal=1; %..presnost 
Rkal=1; %..akce

% simulace
y = zeros(1,length(w));
for k = 2:length(w)-Nn
    y(k)= C*x + D*u(k-1);

    wHorizont = w(k:k+Nn-1)';
    [K, l]=LQoptimise(A, B, C, D, 0, Q, R, wHorizont);
    u(k)=-K*x+l;
    
    x = A*x + B*u(k);
end

clf;
stairs(T(1:end-1),w,'-b');
hold on; 
stairs(T(1:end-1),y,'-r');
stairs(T(1:end-1),u,':k');
legend('w','y','u');
hold off;

