%tracking of mouse 2D-movement
%inspired on https://www.cs.utexas.edu/~teammco/misc/kalman_filter/
f=@(x) sin(x)+cos(x.^0.5); %sin(x);
x=1:0.1:4*pi;
y=f(x);
rng('default');
ym=f(x)+randn(1,length(x))*0.2;
stateHist=zeros(4,length(x));

%inicialization
A=[1 0 0.3 0; %x 
   0 1 0 0.3; %y
   0 0 1 0; %x velocity
   0 0 0 1];%y velocity
C=[1 0 1 0; 0 1 0 1;
   0 0 0 0; 0 0 0 0]; %nemerime
state=[0;0;0;0]; 
outY=C*state; % + D*u
stateHist(:,1)=state; 
P=eye(4,4)*1; I=eye(4,4);
Q=[0 0 0 0;  
   0 0 0 0; 
   0 0 1 0; 
   0 0 0 1]*0.2; %Action Uncertainty
R=eye(4,4)*0.2; %Sensor Noise
%simulation
for i=2:length(x)
    %prediction
    predictedState=A*state;
    Pnew=A*P*A'+Q;
    %correction
    actOutMeasure=[x(i); ym(i);0;0];
    L=Pnew*C'*inv(C*Pnew*C'+R);
    predictedOut = C*predictedState;
    state=predictedState+L*(actOutMeasure-predictedOut); 
    P=(I-L*C)*Pnew;
    
    stateHist(:,i)=state();
end

hold on;
plot(x, y, 'g');
plot(x, ym, 'kx');
plot(stateHist(1,:), stateHist(2,:), 'r');
% grid on;
