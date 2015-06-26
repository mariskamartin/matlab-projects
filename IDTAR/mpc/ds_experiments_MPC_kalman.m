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
x = [0; 0]; %initial state - vertical

u = zeros(1,numOfValues*3); %input data for step
w = [0*ones(1,numOfValues) 1.5*ones(1,numOfValues) 0*ones(1,numOfValues)]; %reference variable
T = 0:Ts:length(u)*Ts; %time data

% inicializace regulatoru
N = 20; %horizont
R = eye(N); %pri neomezenem zasahu a malem R, R = eye(N)*1e-5; se dostaneme na DeadBeat regulaci
Q = eye(N); Qn = eye(length(x)); %Qn ... penalizace koncoveho stavu
[Syx,Syu,Sxx,Sxu] = predictiveMatrixes(A,B,C,N);
Zx = inv(eye(length(A))-A)*B;
Zxy = Zx*inv(C*Zx+D);
M = R+Syu'*Q*Syu+Sxu'*Qn*Sxu;
un0=zeros(N,1);
opt=optimset('Algorithm','active-set','LargeScale','off','Display','off'); %parametry pro ompitmalizaci v quadprog
%s omezenim
qA = [eye(N); -eye(N)];
umax = 2; umin = -2;
%kalman init
Rk=1;  % Covariation Matrix for process Uncertainty %male cislo, protoze nemame na vstupu chybu
Qk=1; %Covariation Matrix for output Uncertainty
kalEstimator = KalmanEstimator(A,B,C,D,Qk,Rk, x);

% simulace
y = zeros(1,length(u));
for k = 2:length(u)-N
%     x=A*x+B*u(k-1);
    y(k)=C*x+D*u(k-1); % predpoklad ze u(k) ma z minula stale stejnou honodtu: y(k)= C*x + D*u(k-1)
    % estimation
    [~, x] = kalEstimator.estimate(u(k-1), y(k));
    un0=[un0(2:end); un0(end)]; %shift minulych hodnot
    dxn=Zxy*w(k+N-1)-Sxx*x-Sxu*un0;
    wn=w(k:k+N-1)'; % wn=w(k)*ones(N,1);
    dwn=wn-Syx*x-Syu*un0;
    m=-(Sxu'*Qn*dxn+Syu'*Q*dwn);
%     du=-M\m; %analiticke reseni  %quadprog(M,m); %bez omezeni
    %priprava pro omezeni
    qb = [umax-un0; un0-umin];
    du = quadprog(M, m, qA, qb,[],[],[],[],[],opt);
    un0=un0+du; %aktualizace pro dalsi kolo 
    u(k)=un0(1);
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

