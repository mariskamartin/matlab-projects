clear; clc;
%vytvoreni systemu
sysTF = tf([1 1], [1 0]);

%synteza regulatoru -------------------------------------------------------
%zvolene poly vysledne prenosove funkce
% poles = [1 5 6]; %(s + 3)(s + 2)
% poles = [1 7 10]; %(s + 3)(s + 2)
% poles = [1 2 5]; % -1 +- 2i
poles = [1 3]; %(s + 3)(s + 2)

%navrh pomoci diofanticke rovnice, z B/A na Y/X\
B = sysTF.num{1};
A = sysTF.den{1};
[X, Y] = diofant(A, B, poles);

regulatorTF = tf(Y,X);
Furo = tf(conv(Y, B), conv(X,A) + conv(Y, B));
step(Furo);
% -------------------------------------------------------------------------

%vytvoreni systemu k simulaci
% closedLoopSystem = feedback(regulatorTF * motorTF, -1);
closedLoopSystem = Furo;

%step(closedLoopSystem);

% generovani simulacnich dat
timeData = 0:0.05:4.99;
inputData = createData([0.7 0.25 1 0.5 0.3], floor(length(timeData)/5));
[u,t] = gensig('square',9,30,0.1);

%simulace
% lsim(closedLoopSystem, inputData, timeData); %pripadne , x0 pro nenulove pocatecni podminky systemu
lsim(closedLoopSystem, u, t); %pripadne , x0 pro nenulove pocatecni podminky systemu





