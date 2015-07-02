clear; clc;

valuesCount = 150;  % 15 s
Ts = 0.1;           %time stamp / vzorkovaci perioda
sysTF = tf(1,[1 1 1]); 
x = [0; 0];

sysTFDiscrete=c2d(sysTF,Ts); %to discreet representation
[A,B,C,D]=ssdata(sysTFDiscrete); %to state space model
Nx = size(A,1);
Nu = size(B,2);

%synteza regulatoru -------------------------------------------------------
%zvolene poly vysledne prenosove funkce
% poles = [1 2 5]; % -1 +- 2i 
poles = conv([1/3 1], [1/2 1]); %(s+3)(s+2)
%prevod na diskterni poly
poles = c2d(tf(1, poles),Ts);
poles = poles.den{1}; 

%navrh pomoci diofanticke rovnice, z B/A na Y/X
Bpa = sysTFDiscrete.num{1};
Apa = sysTFDiscrete.den{1};
[X, Y, R] = PAdiofant(Apa, Bpa, poles, true);
% -------------------------------------------------------------------------
% simulace
w = [0.5*ones(1,valuesCount) 1*ones(1,valuesCount) 0*ones(1,valuesCount)]; % zadana / reference values
t = 0:Ts:length(w)*Ts;      % cas / time
y = zeros(1, length(w));
u = zeros(1, length(w));
for k = 2:length(w)
    x = A*x + B*u(k-1); % state update
    y(k)= C*x + D*u(k-1); % output

    %PA control
    %zde je potreba dosadit v poradi [k k-1 k-2 ...], 
    %protoze pouzivame z^2+a1*z+a0 > [k+2 k+1 k] 
    wh = swap(w(k-length(R)+1:k)); 
    yh = swap(y(k-length(Y)+1:k));
    uh = swap(u(k-length(X)+1:k));
    u(k) = (w(k)*R+(-yh)*Y'+(-uh)*X')/X(1); %u(k) = (wh*R' + (-yh)*Y' + (-uh)*X') / x0; 
end
% tisk vysledku
figure;
stairs(t(1:end-1),w,'-b');
hold on; 
stairs(t(1:end-1),y,'-r');
stairs(t(1:end-1),u,':k');
legend('w','y','u');
hold off;



