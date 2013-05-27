%Navazuje na zpusteni IdentifikaceSISO.mdl
t=data.signals.values(:,1)';
u=data.signals.values(:,2)';
y=data.signals.values(:,3)';

%Vykresleni namerenych dat
figure
stairs(t,u,'r','LineWidth',2);
hold on
plot(t,y,'LineWidth',2)
grid
legend('Vstup u','Vystup y')
xlabel('t')
ylabel('u(t), y(t)')

%Vytvoreni instance tridy SatNet a trenovani
vstup = [y(1:end-1);u(1:end-1)];
vystup = y(2:end);
SN = SatNet(vstup,vystup,6);
SN.Init;
SN.TrenovaniDE(10,0.1,20); %10 epoch, alfa = 0.1, 20 jedincu v populaci

%Testovani autonomniho chovani neuronoveho modelu
hist = [-1;-1]; %Vektor hodnot [y(k),u(k)]
y2 = zeros(size(u));
for k = 1:1:length(u),
    y2(k) = SN.Simulace(hist);
    hist = [y2(k);u(k)]; %Vicekrokova predikce
    %hist = [y(k);u(k)]; %Jednokrokova predikce
end

%Vykresleni namerenych dat proti vystupum z modelu
figure
stairs(t,u,'r','LineWidth',2);
hold on
plot(t,y,'LineWidth',2)
plot(t,y2,'g','LineWidth',2)
grid
legend('Vstup u','Vystup y','Vystup z modelu y_M')
xlabel('t')
ylabel('u(t), y(t)')

%Vytvoreni regulatoru
D = [1 -1.6 0.68]; %Ocekavana dynamika RP
Regula = Regulator(-1,1,SN,D);
