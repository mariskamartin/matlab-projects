function [A, B]=MNC(y,u,na,nb)
%
%funkce resi metodou nejmensich ctvercu rovnici:
%          Y = X * G,
%kde G = [a(1); a(2); ...; a(na); b(1); b(2); ...; b(nb)]
%    X = [-y(na)   -y(na-1)  ...  -y(1)   b(nb)   ...   b(1)
%         -y(na-1) -y(na-2)  ...  -y(2)   b(nb-1) ...   b(2)
%         ...      ...       ...  ...     ...     ...   ...]
%
%
%
N=length(y);
n=max(na,nb);
X=zeros(N-n,na+nb);
for j=1:na,
    for i=1:N-n,
        X(i,j)=-y(n+i-j);
    end
end
for j=na+1:na+nb,
    for i=1:N-n,
        X(i,j)=u(na+n+i-j);
    end
end
Y=y(n+1:end)';
c1=inv(X'*X);
c2=c1*X';
G=c2*Y;
A=[1;G(1:na)]';
B=[0;G(na+1:end)]';
