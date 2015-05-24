%tracking of mouse 2D-position
%inspired on https://www.cs.utexas.edu/~teammco/misc/kalman_filter/
f=@(x) 2.3; %sin(x);
x=1:0.1:4*pi;
y=f(x);
measureNoise=randn(1,length(x))*0.2; %rng('default'); %for stable random seed
yMeasured=f(x)+measureNoise;
stateHist=zeros(2,length(x));

%inicialization
A=[1 0; %x 
   0 1]; %y
C=[1 0; 
   0 1];
state=[0;0];  stateHist(:,1)=state; 
P=eye(2,2)*1; 
I=eye(2,2);
Q=[0 0;  
   0 0]*0.2; %Covariation Matrix for Action Uncertainty
R=eye(2,2)*0.2; %Covariation Matrix for Sensor Noise

%simulation
for i=2:length(x)
    %prediction
    predictedState=A*state; % xNew = Ax + B*u
    Pnew=A*P*A'+Q;
    %correction
    actOutMeasure=[x(i); yMeasured(i)];
    L=Pnew*C'*inv(C*Pnew*C'+R);
    predictedOut = C*predictedState; % y = C*x + D*u;
    state=predictedState+L*(actOutMeasure-predictedOut); 
    P=(I-L*C)*Pnew;
    
    stateHist(:,i)=state;
end

hold on;
plot(x, y, 'g');
plot(x, yMeasured, 'kx');
plot(stateHist(1,:), stateHist(2,:), 'r');
legend('original', 'measurements', 'kalman estimation');
ylabel('y position'), xlabel('x position');
