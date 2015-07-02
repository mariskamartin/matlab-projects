clear all;
Ts = 0.1; %time stamp / vzorkovaci perioda
%vytvoreni systemu
sysTF = tf(1,[1 1 1]); 
step(sysTF, 'b:');

D=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(D); %to state space model
Nx = size(A,1);
x = zeros(Nx, 1);

u = ones(1,70); %input data for step
t = 0:Ts:(length(u)*Ts)-Ts; %time data

y = zeros(1,length(u));
for k = Nx:length(u)
    x = A*x + B*u(k-1);
    y(k)= C*x + D*u(k-1);
end

hold on; 
stairs(t,y,'-r');
