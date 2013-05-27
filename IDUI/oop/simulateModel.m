help = ones(1,60);
%prubeh zadane
simInput = [help*0.1 help*-0.6 help*0.9 help*-0.2];
%inicilalizace vystupniho vektoru
simOutput = zeros(length(simInput),1);

dnnModel.initSystem(2); % parametr je rad soustavy

for k = 1:length(simInput)
    simOutput(k) = dnnModel.simulate(simInput(k));
end

%vykresleni prubehu
vykreslitPrubeh( 1:length(simInput), simInput, simOutput );

%uklidit
clear('help');