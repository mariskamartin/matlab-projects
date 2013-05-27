%Navazuje na zpusteni IdentifikaceSISO.mdl
trimCount = 5000; %omezeni dat
t=data.signals.values(1:trimCount,1)'; %t,u,y .. radkove vektory
u=data.signals.values(1:trimCount,2)';
y=data.signals.values(1:trimCount,3)';

%Vykresleni namerenych dat
% vykreslitPrubeh( t, u, y );

%vytvoreni dynamickeho modelu
% mnet = createNNModel(u, y);

help = ones(1,60);
simInput = [help*0.1 help*-0.6 help*0.9 help*-0.2];
u1 = -1;
u2 = -1;
y1 = -1;
y2 = -1;
simY = zeros(length(simInput));
for k = 1:length(simInput)
    u1 = simInput(k);
    simY(k) = sim(net, [y1;y2;u1;u2]);
    y2 = y1;
    y1 = simY(k);
    u2 = u1;
end

vykreslitPrubeh( 1:length(simInput), simInput, simY );