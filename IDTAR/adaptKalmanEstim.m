function [xNew, Pnew]=adaptKalmanEstim(A, B, C, D, Ge, Q, R, x, yk, uk, P)
% Implementace adaptivniho kamanova estimatoru. [Dusek INPRE Pokrocile ridici systemy]
% Estimace vektoru stavu soustavy na zaklade u(k) a y(k) a parametru sumu.
%Promenne:
%   A, B, C, D ... stavovy popis soustavy
%   Ge         ... matice vah sumu ve stavu
%   Q          ... rozptyl sumu ve stavu
%   R          ... rozptyl sumu na vystupu
%   uk, yk     ... aktualni vstup a vystup
%   P          ... historie kovariancni matice (hodnota 0, pro zacatek)
if (P==0)
    P=Ge*Q*Ge';
end
%aktualizace kalmanova zesileni
L=A*P*C'*inv(C*P*C'+R);
%aktualizace odhadu stavu
xNew=A*x+B*uk+L*(yk-C*x-D*uk);
%aktualizace kovariancni matice
Pnew=A*P*A'-L*(C*P*C'+R)*L'+Ge*Q*B';