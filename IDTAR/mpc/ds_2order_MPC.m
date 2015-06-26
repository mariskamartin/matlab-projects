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
N = 10; %horizont
R = eye(N);
Q = eye(N); Qn = eye(length(x)); %Qn ... penalizace koncoveho stavu
[Syx,Syu,Sxx,Sxu] = MPC.predictiveMatrixes(A,B,C,N);
Zx = inv(eye(length(A))-A)*B;
Zxy = Zx*inv(C*Zx+D);
M = R+Syu'*Q*Syu+Sxu'*Qn*Sxu;
un0=zeros(N,1);
opt=optimset('Algorithm','active-set','LargeScale','off','Display','off'); %parametry pro ompitmalizaci v quadprog
%s omezenim
qA = [eye(N); -eye(N)];
umax = 1.5; umin = -1.5;

% simulace
y = zeros(1,length(u));
for k = 2:length(u)-N
    x=A*x+B*u(k-1);
    y(k)=C*x+D*u(k-1); % predpoklad ze u(k) ma z minula stale stejnou honodtu: y(k)= C*x + D*u(k-1)
    un0=[un0(2:end); un0(end)]; %shift minulych hodnot
    dxn=Zxy*w(k+N-1)-Sxx*x-Sxu*un0;
    wr=w(k:k+N-1)'; % wn=w(k)*ones(N,1);
    dwn=wr-Syx*x-Syu*un0;
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

