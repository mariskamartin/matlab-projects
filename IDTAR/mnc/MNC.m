function [A, B]=MNC(y,u,na,nb)
%Offline metoda nejmensich ctvercu. zdroj: skriptum INPRE, Dušek F.
%funkce vzpocita parametry a.., b.. pomoci metody nejmensich ctvercu:
%          Y = D * P,
%          y(k) = B(1)*u(k-1)+B(2)*u(k-2)-A(1)*y(k-1)-A(2)*y(k-2) 
% P ... vektor parametru
% D ... datova matice
%kde P = [a(1); a(2); ...; a(na); b(1); b(2); ...; b(nb)]
%    D = [-y(na)   -y(na-1)  ...  -y(1)   b(nb)   ...   b(1)
%         -y(na-1) -y(na-2)  ...  -y(2)   b(nb-1) ...   b(2)
%         ...      ...       ...  ...     ...     ...   ...]
%
N=length(y);
n=max(na,nb);
D=zeros(N-n,na+nb);
for j=1:na,
    for i=1:N-n,
        D(i,j)=-y(n+i-j);
    end
end
for j=na+1:na+nb,
    for i=1:N-n,
        D(i,j)=u(na+n+i-j);
    end
end
Y=y(n+1:end)';
P=inv(D'*D)*D'*Y; % P = inv(D'D)*D'*Y - P je odhad stredni hodnoty parametru
A=P(1:na)';
B=P(na+1:end)';
