function [A, B]=MNC(y,u,na,nb)
%Offline metoda nejmensich ctvercu. zdroj: skriptum INPRE, Dušek F.
%funkce vzpocita parametry a.., b.. pomoci metody nejmensich ctvercu:
%          Y = D * P,
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
h1=inv(D'*D);
h2=h1*D';
P=h2*Y; % P = inv(D'D)*D'*Y - P je odhad stredni hodnoty parametru
A=[1; P(1:na)]';
B=[0; P(na+1:end)]';
