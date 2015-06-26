%
% Simulace soustavy druheho radu.
% s MPC regulatorem
%

clear all;
Ts = 0.1; %time stamp / vzorkovaci perioda
numOfValues = 100; %number of values in one step 
%vytvoreni systemu 2. radu
sysTF = tf(1,[1 1 1]); 

D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model

u = zeros(1,numOfValues*3); %input data for step
w = [0*ones(1,numOfValues) 1*ones(1,numOfValues) 0*ones(1,numOfValues)]; %reference variable
T = 0:Ts:length(u)*Ts; %time data
x = [0; 0]; %initial state - vertical

% inicializace regulatoru
N = 20; %horizont
R = eye(N);
Q = 100*eye(N); 
Qn = eye(length(x)); %Qn ... penalizace koncoveho stavu
mpc = MPC(A,B,C,D,Qn,Q,R,N);
%s omezenim
mpc.setInputMinMax(-0.5, 1.5)

% simulace
y = zeros(1,length(u));
for k = 2:length(u)-N
    x=A*x+B*u(k-1);
    y(k)=C*x+D*u(k-1); % predpoklad ze u(k) ma z minula stale stejnou honodtu: y(k)= C*x + D*u(k-1)
    u(k)=mpc.evalControlAction(x, w(k:k+N-1)');
end

figure;
stairs(T(1:end-1),w,'-b');
hold on; 
stairs(T(1:end-1),y,'-r');
stairs(T(1:end-1),u,':k');
legend('w','y','u')
hold off; 
% grid on;
axis([0 T(end) -3 5]);

