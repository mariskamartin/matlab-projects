clear; clc;
% %vytvoreni systemu
% % sysTF = tf([0 0 2],[1 2 5]) %zatim nelze
% % sysTF = tf([0 1 6],[1 1 1])
% sysTF = tf([1 1],[1 1 1])
% step(sysTF);
% figure;

valuesCount = 150;  % 15 s
Ts = 0.1;           %time stamp / vzorkovaci perioda
wn = 20;            % delka horizontu rizeni
sysTF = tf([1],[1 1 1]); 
x = [0; 0];

sysTFDiscrete=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(sysTFDiscrete); %to state space model
Nx = size(A,1);
Nu = size(B,2);

%synteza regulatoru -------------------------------------------------------
%zvolene poly vysledne prenosove funkce
% poles = [1 10 25]; %(s + 5)(s + 5)
% poles = [1 4 4]; %(s + 2)(s + 2)
% poles = [1 8 12]; %(s + 6)(s + 2)
% poles = conv([1 3], [1 2]);; %(s + 3)(s + 2) 
poles = conv([1/2 1], [1/1.1 1]); %(s + 1)
% poles = conv([1/3 1], [1/2 1]); %(1/3s + 1)(1/2s + 1) 
% poles = [1 2 5]; % -1 +- 2i

%navrh pomoci diofanticke rovnice, z B/A na Y/X\
Bpa = sysTF.num{1};
Apa = sysTF.den{1};
[X, Y, R] = PAdiofant(Apa, Bpa, poles);
% [~, R] = diofant(zeros(1, length(B)), B, poles);
% R = lpad([1],length(Bpa));
% R = [0 1 2]; %tf(1, B) * tf(poles, 1); %R = poles / B
% regulatorTF = tf(Y,X);
% -------------------------------------------------------------------------

% %vytvoreni systemu k simulaci
% closedLoopSystem = tf(conv(R, B), conv(X,A) + conv(Y, B));
% step(closedLoopSystem);
% figure;
% 
% % generovani simulacnich dat
% timeData = 0:0.01:4.99;
% inputData = createData([0.7 0.25 1 0.5 0.3], floor(length(timeData)/5));
% [u,t] = gensig('square',9,30,0.1);
% 
% %simulace
% % lsim(closedLoopSystem, inputData, timeData); %pripadne , x0 pro nenulove pocatecni podminky systemu
% lsim(closedLoopSystem, u, t); %pripadne , x0 pro nenulove pocatecni podminky systemu

% simulace
w = [0.5*ones(1,valuesCount) 1*ones(1,valuesCount) 0*ones(1,valuesCount)]; % zadana / reference values
t = 0:Ts:length(w)*Ts;      % cas / time
y = zeros(1, length(w));
u = zeros(1, length(w));
for k = 2:length(w)
    x = A*x + B*u(k-1); % state update
    y(k)= C*x + D*u(k-1); % output

    %PA control
    u(k) = 0;
%     wh = w(k-2:k);
    yh = y(k-length(Y)+1:k);
    uh = u(k-length(X)+1:k);
    ct = w(k) + (-yh)*Y' + (-uh)*X'; %ct = wh*R' + (-yh)*Y' + (-uh)*X'; 
    u(k) = ct/X(end);
end
% tisk vysledku
figure;
stairs(t(1:end-1),w,'-b');
hold on; 
stairs(t(1:end-1),y,'-r');
stairs(t(1:end-1),u,':k');
legend('w','y','u');
hold off;



