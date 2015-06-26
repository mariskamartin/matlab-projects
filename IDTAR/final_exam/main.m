clear all;
% soustava (stavovy popis - A,B,C,D)
    valuesCount = 150;  % 15 s
    Ts = 0.1;           %time stamp / vzorkovaci perioda
    wn = 20;            % delka horizontu rizeni
    sysTF = tf([0 1],[1 1 1]); 
    x = [0; 0];
    
    sysTFDiscrete=c2d(sysTF,Ts); %to discreet representation
    [A,B,C,D]=ssdata(sysTFDiscrete); %to state space model
    Nx = size(A,1);
    Nu = size(B,2);    
    
% identifikace
    %step(sysTF); % skokova funkce
    % KALMAN
        Rk=0.1;  % Covariation Matrix for process Uncertainty %male cislo, protoze nemame na vstupu chybu
        Qk=1; %Covariation Matrix for output Uncertainty
        kalEstimator = KalmanEstimator(A,B,C,D,Qk,Rk,x);

% inicializace regulatoru
    % PID
        pid = PIDreg(5, 2, 0, Ts); 
    % PA
        %poles = [1/2 1]; %(1/2s + 1) ..1. order
        poles = conv([1/3 1], [1/2 1]); %(1/3s + 1)(1/2s + 1) ... 2. order
        citatel = sysTF.num{1}; jmenovatel = sysTF.den{1};        
        %[X, Y, R] = PAdiofant(jmenovatel, citatel, poles);    
        %closedLoopSystem = tf(conv(R, citatel), conv(X,jmenovatel) + conv(Y, citatel));
        %[A,B,C,D]=ssdata(c2d(closedLoopSystem,Ts)); %to discreet representation, to state space model
    % LQ
        Rlq = 0.1;     % matice penalizaci akcnich zasahu
        Qlq = 1;        % matice penalizaci regulacnich odchylek
    % MPC
        R = eye(wn); %zasah
        Q = 100*eye(wn); %odchylky
        Qn = eye(length(x)); % penalizace koncoveho stavu
        mpc = MPC(A,B,C,D,Qn,Q,R,wn);
        %mpc.setInputMinMax(-2, 2); %s omezenim

% simulace
    w = [0.5*ones(1,valuesCount) 1*ones(1,valuesCount) 0*ones(1,valuesCount)]; % zadana / reference values
    t = 0:Ts:length(w)*Ts;      % cas / time
    y = zeros(1, length(w));
    u = zeros(1, length(w));
    for k = 2:length(w)-wn
%         x = A*x + B*u(k-1); % state update
        y(k)= C*x + D*u(k-1); % output
        % estimation
        [ye, x] = kalEstimator.setPlant(A,B,C,D).estimate(u(k-1), y(k));

        %no control
            u(k) = w(k);
        %PID control
            %u(k) = pid.evalControlAction(w(k), y(k));
        %PA control
            %uncomment others in init
            %u(k) = w(k); 
        %LQ control
            [K, l] = LQoptimise(A, B, C, D, 0, Qlq, Rlq, w(k:k+wn-1)');
            u(k)=-K*x+l;        
        %MPC control
            %u(k)=mpc.evalControlAction(x, w(k:k+wn-1)');
        
    end
% tisk vysledku
    figure;
    stairs(t(1:end-1),w,'-b');
    hold on; 
    stairs(t(1:end-1),y,'-r');
    stairs(t(1:end-1),u,':k');
    legend('w','y','u');
    hold off;