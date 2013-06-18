t = 0:0.75:(0.75*length(simout(:,1))-0.5);
hold on;
stairs(t, simout(:,1));
stairs(t, simout(:,2), 'r');
% plot(t, simout(:,2), 'r');
% stairs(t, simout(:,3), 'm');
xlabel('Èas'), 
% legend('w','y DIC','y IMC'); 
legend('u','y'); 
% legend('w','y'); 
% legend('w','u', 'y'); 
% legend('w','y','y nn'); 
% grid on;
hold off;