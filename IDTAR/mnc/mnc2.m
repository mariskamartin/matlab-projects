%VSTUP
%X-vektor bod�
%Y-vektor funk�n�ch hodnot v t�chto bodech
%W-vektor vah
%m-stupe� polynomu, kter�m data aproximujeme
%V�STUP
%vektor-vektor koeficient� nejlep�� aproximace ve smyslu metody
%nejmen��ch �tverc�
%zdroj: http://mant.upol.cz/soubory/OdevzdanePrace/B09/b09-19-jv.pdf
function vektor=mnc2(X,Y,W,m)
if m<0
    error('Chyba na vstupu: stupe� polynomu mus� b�t nez�porn� ��slo')
elseif(m~=round(m))
    error('Chyba na vstupu: po�et funkc� mus� b�t cel� ��slo')
elseif (length(X)~=length(Y))
    error('Chyba na vstupu: Neshoduje se po�et bod� a funk�n�ch hodnot')
elseif (length(X)~=length(W))
    error('Chyba na vstupu: Neshoduje se po�et bod� a d�lka v�hov�ho vektoru')
elseif any(W<=0)
    error('Chyba na vstupu: slo�ky v�hov� funkce mus� b�t kladn� ��sla')
elseif (length(X)<m+1)
    error('Chyba na vstupu: nulov� odchylky dosa�eno ji� pro m=%d,nem� v�znam hledat aproximace vy���ho stupn� ', length(X)-1)
else
    %%vytvo�en� matice koeficient� funkc� phi=x^i
    Phi=zeros(m+1);
    for i=1:m+1
        Phi(i,m+2-i)=1;
    end
    %% vytvo�en� matice norm�ln� soustavy
    MNS = zeros(m+1);
    for i = 1:(m+1)
        for j = i:(m+1)
            MNS(i,j) = polyval(Phi(i,:),X)*polyval(Phi(j,:),X)';
        end
        for j = 1:(i-1)
            MNS(i,j) =MNS(j,i);
        end
    end
    %%vektor prav�ch stran
    f=zeros(1,m+1);
    for i=1:(m+1)
        f(i)=Y*polyval(Phi(i,:),X)';
    end
    %%v�po�et koeficient� c(i)
%     format rat;
    c=MNS\f';
    %%uspo��d�n� koeficient� c(i) do tvaru kone�n�ho polynomu
    vektor=0;
    for i=1:length(c)
        vektor(i)=c(length(c)+1-i);
    end
end
%%graf
x=min(X):0.01:max(X);
%vy��slen� polynomu c v bodech x
y=polyval(vektor,x);
plot(x,y,'b')
hold on
plot(X,Y,'rx')