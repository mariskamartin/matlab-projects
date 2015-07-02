clear all;
% soustava (stavovy popis - A,B,C,D)
    valuesCount = 150;  % 15 s
    Ts = 0.1;           % time stamp / vzorkovaci perioda
    wn = 20;            % delka horizontu rizeni (kroku)
%     sysTF = tf([-0.5 1],[1 3 3 1]); %system s neminimalni fazi
    sysTF = tf([0 1],[1 1 1]); 
    
    
    sysTFDiscrete=c2d(sysTF,Ts); %to discreet representation
    [A,B,C,D]=ssdata(sysTFDiscrete); %to state space model
    Nx = size(A,1);
    Nu = size(B,2);    
    x = zeros(Nx, 1);
    
% identifikace
    %step(sysTF); % skokova funkce
    % KALMAN
        Rk=0.1;  % Covariation Matrix for process Uncertainty %male cislo, protoze nemame na vstupu chybu
        Qk=1; %Covariation Matrix for output Uncertainty
        kalEstimator = KalmanEstimator(A,B,C,D,Qk,Rk,x);

% inicializace regulatoru
    % PID
        pid = PIDreg(12.3, 10, 2.5, Ts);
    % PA
        %poles = [1/2 1]; %(1/2s + 1) ..1. order
        poles = conv([1/3 1], [1/2 1]); %(1/3s + 1)(1/2s + 1) ... 2. order
        %prevod na diskterni poly
        poles = c2d(tf(1, poles),Ts);
        poles = poles.den{1}; 
        %navrh pomoci diofanticke rovnice, z B/A na Y/X
        Bpa = sysTFDiscrete.num{1};
        Apa = sysTFDiscrete.den{1};
        [Xpa, Ypa, Rpa] = PAdiofant(Apa, Bpa, poles, true);        
    % LQ
        Rlq = 0.001;     % matice penalizaci akcnich zasahu
        Qlq = 1;         % matice penalizaci regulacnich odchylek
        Qnlq = eye(Nx);  % penalize koncoveho stavu
    % MPC
        R = 0.001*eye(wn);  %zasah
        Q = eye(wn);        %odchylky
        Qn = 0*eye(length(x)); % penalizace koncoveho stavu
        mpc = MPC(A,B,C,D,Qn,Q,R,wn);
        %mpc.setInputMinMax(-2, 2); %s omezenim

% simulace
    w = [0.5*ones(1,valuesCount) 1*ones(1,valuesCount) 0*ones(1,valuesCount)]; % zadana / reference values
    t = 0:Ts:(length(w)*Ts-Ts);      % cas / time
    y = zeros(1, length(w));
    u = zeros(1, length(w));
    for k = Nx:length(w)-wn
        x = A*x + B*u(k-1); % state update
        y(k)= C*x + D*u(k-1); % output
        % estimation
        %[ye, xe] = kalEstimator.setPlant(A,B,C,D).estimate(u(k-1), y(k));

        %no control
            %u(k) = w(k);
        %PID control
            %u(k) = pid.evalControlAction(w(k), y(k));
        %PA control
            %zde je potreba dosadit v poradi [k k-1 k-2 ...], 
            %protoze pouzivame z^2+a1*z+a0 > [k+2 k+1 k] 
            wh = swap(w(k-length(Rpa)+1:k)); 
            yh = swap(y(k-length(Ypa)+1:k));
            uh = swap(u(k-length(Xpa)+1:k));
            u(k) = (wh*Rpa'+(-yh)*Ypa'+(-uh)*Xpa')/Xpa(1); %u(k) = (wh*R' + (-yh)*Y' + (-uh)*X') / x0; 
        %LQ control
            %[K, l] = LQoptimise(A, B, C, D, Qnlq, Qlq, Rlq, w(k:k+wn-1)');
            %u(k)=-K*x+l;        
        %MPC control
            %u(k)=mpc.evalControlAction(x, w(k:k+wn-1)');
        
    end
% tisk vysledku
    figure;
    stairs(t,w,'-b');
    hold on; 
    stairs(t,y,'-r');
    stairs(t,u,':k');
    legend('w','y','u');
    hold off;