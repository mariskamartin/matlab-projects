%VSTUP
%X-vektor bodù
%Y-vektor funkèních hodnot v tìchto bodech
%W-vektor vah
%m-stupeò polynomu, kterým data aproximujeme
%VÝSTUP
%vektor-vektor koeficientù nejlepší aproximace ve smyslu metody
%nejmenších ètvercù
%zdroj: http://mant.upol.cz/soubory/OdevzdanePrace/B09/b09-19-jv.pdf
function vektor=mnc2(X,Y,W,m)
if m<0
    error('Chyba na vstupu: stupeò polynomu musí být nezáporné èíslo')
elseif(m~=round(m))
    error('Chyba na vstupu: poèet funkcí musí být celé èíslo')
elseif (length(X)~=length(Y))
    error('Chyba na vstupu: Neshoduje se poèet bodù a funkèních hodnot')
elseif (length(X)~=length(W))
    error('Chyba na vstupu: Neshoduje se poèet bodù a délka váhového vektoru')
elseif any(W<=0)
    error('Chyba na vstupu: složky váhové funkce musí být kladná èísla')
elseif (length(X)<m+1)
    error('Chyba na vstupu: nulové odchylky dosaženo již pro m=%d,nemá význam hledat aproximace vyššího stupnì ', length(X)-1)
else
    %%vytvoøení matice koeficientù funkcí phi=x^i
    Phi=zeros(m+1);
    for i=1:m+1
        Phi(i,m+2-i)=1;
    end
    %% vytvoøení matice normální soustavy
    MNS = zeros(m+1);
    for i = 1:(m+1)
        for j = i:(m+1)
            MNS(i,j) = polyval(Phi(i,:),X)*polyval(Phi(j,:),X)';
        end
        for j = 1:(i-1)
            MNS(i,j) =MNS(j,i);
        end
    end
    %%vektor pravých stran
    f=zeros(1,m+1);
    for i=1:(m+1)
        f(i)=Y*polyval(Phi(i,:),X)';
    end
    %%výpoèet koeficientù c(i)
%     format rat;
    c=MNS\f';
    %%uspoøádání koeficientù c(i) do tvaru koneèného polynomu
    vektor=0;
    for i=1:length(c)
        vektor(i)=c(length(c)+1-i);
    end
end
%%graf
x=min(X):0.01:max(X);
%vyèíslení polynomu c v bodech x
y=polyval(vektor,x);
plot(x,y,'b')
hold on
plot(X,Y,'rx')