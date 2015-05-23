%
% Tento skript neni dokonceny a ma se snazit regulovat soustavu motoru
% (system druheho radu)
%
clear; clc;

m = Motor();
%zjistime jaky je jmenovatel
sys = m.getTF();
%zvolene poly
% poles = [1 5 6]; %(s + 3)(s + 2)
poles = [1 12 35]; %(s + 5)(s + 7)

%polynomy prenosove funkce
% B = [0 0 2];
% A = [1 12 20.02];
B = sys.num{1}; %jmenovatel tf
A = sys.den{1}; %citatel tf

%reseni pomoci diofanticke rovnice
[X, Y] = diofant(A, B, poles);
[~, R] = diofant(zeros(1, length(B)), B, poles);

% podminka pro existenci reseni soustavy lin rovnic.
% rank([A b]) == rank(A)

controllerTF = tf(Y,X);

x0 = [0 0]; %pro pripad nenunlovych pocatecnich podminek.. si doplnit nenulove
t = 0:0.05:5;
u = createData([0.25 1 0.5 0.3 0.7], floor(length(t)/5));
u = [u 0];

sys_cl = feedback(controllerTF * m.getTF(), -1); %vyrobeni ridici odchylky
lsim(sys_cl, (u .* -10), t, x0);