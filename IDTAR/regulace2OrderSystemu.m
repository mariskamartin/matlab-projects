clear; clc;
%vytvoreni systemu
% sysTF = tf([0 0 2],[1 2 5]) %zatim nelze
% sysTF = tf([0 1 6],[1 1 1])
sysTF = tf([0 1 1],[1 1 1])
step(sysTF);
figure;


%synteza regulatoru -------------------------------------------------------
%zvolene poly vysledne prenosove funkce
% poles = [1 10 25]; %(s + 5)(s + 5)
% poles = [1 4 4]; %(s + 2)(s + 2)
% poles = [1 8 12]; %(s + 6)(s + 2)
% poles = conv([1 3], [1 2]);; %(s + 3)(s + 2) 
poles = conv([1/3 1], [1/2 1]); %(1/3s + 1)(1/2s + 1) 
% poles = [1 2 5]; % -1 +- 2i

%navrh pomoci diofanticke rovnice, z B/A na Y/X\
B = sysTF.num{1};
A = sysTF.den{1};
[X, Y] = diofant(A, B, poles);
% [~, R] = diofant(zeros(1, length(B)), B, poles);
R = lpad([1],length(B));
% R = [0 1 2]; %tf(1, B) * tf(poles, 1); %R = poles / B
% regulatorTF = tf(Y,X);
% -------------------------------------------------------------------------

%vytvoreni systemu k simulaci
closedLoopSystem = tf(conv(R, B), conv(X,A) + conv(Y, B));
step(closedLoopSystem);
figure;

% generovani simulacnich dat
timeData = 0:0.01:4.99;
inputData = createData([0.7 0.25 1 0.5 0.3], floor(length(timeData)/5));
[u,t] = gensig('square',9,30,0.1);

%simulace
% lsim(closedLoopSystem, inputData, timeData); %pripadne , x0 pro nenulove pocatecni podminky systemu
lsim(closedLoopSystem, u, t); %pripadne , x0 pro nenulove pocatecni podminky systemu





