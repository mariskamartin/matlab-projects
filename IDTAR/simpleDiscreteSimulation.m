clear all;
Ts = 0.1; %time stamp / vzorkovaci perioda
%vytvoreni systemu
sysTF = tf(1,[1 1]); 
step(sysTF, 'b:');

D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model

u = ones(1,70); %input data for step
T = 0:Ts:length(u)*Ts; %time data
x = [0]; %initial state

y = zeros(1,length(u));
for k = 1:length(u)
    xnew = A*x + B*u(k);
    y(k)= C*x + D*u(k);

    x = xnew; %shift
end

hold on; 
stairs(T(1:end-1),y,'-r');
