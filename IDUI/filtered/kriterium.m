function Kr = kriterium(net)
    T = 0:1.5:500;
    bin = cidlo(T);
    Tnn = sim(net,bin);
    Kr = log10((T-Tnn)*(T-Tnn)'/length(T)) + 0.1 * pocetNeuronu(net);
end

function n = pocetNeuronu(net)
    b = net.b;
    n = 0;
for k = 1:1:length(b)
        [r, s] = size(b{k});
        n = n + r * s;
end
end

function k = cidlo(T)
    k = fix(1023*(1-exp(-T/150)));
if k<0
        k=0;
elseif k>1023
        k=1023;
end
end


