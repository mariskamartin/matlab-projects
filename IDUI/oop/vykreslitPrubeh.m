function vykreslitPrubeh( t, u, y )
%VYKRESLITPRUBEH vykresli prubeh zavislosti vstupu a vystupu na case

    hold on
    stairs(u,'r','LineWidth',2);
    plot(t,y,'LineWidth',2)
    grid
    legend('Vstup u','Vystup y')
    xlabel('t')
    ylabel('u(t), y(t)')
    hold off

end

