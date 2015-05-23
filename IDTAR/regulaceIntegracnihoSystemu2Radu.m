clear; clc;
%vytvoreni systemu s integracnim charakterem a 2. radu
sysTF = tf([0 1],[1 1 0]); 
step(sysTF);
figure;

%synteza regulatoru -------------------------------------------------------
%zvolene poly vysledne prenosove funkce
poles = [1 5 6]; %(s + 3)(s + 2)
% poles = [1 2 5]; % -1 +- 2i

%navrh pomoci diofanticke rovnice, z B/A na Y/X\
B = sysTF.num{1};
A = sysTF.den{1};
[X, Y] = diofant(A, B, poles);
regulatorTF = tf(Y,X);
closedLoopSystem = tf(conv(Y, B), conv(X,A) + conv(Y, B));
step(closedLoopSystem);
figure;
% -------------------------------------------------------------------------

% generovani simulacnich dat
t = 0:0.05:19.99;
u = createData([0.7 0.25 1 0.5 0.3], floor(length(t)/5));

%simulace
lsim(closedLoopSystem, u, t); %pripadne , x0 pro nenulove pocatecni podminky systemu





