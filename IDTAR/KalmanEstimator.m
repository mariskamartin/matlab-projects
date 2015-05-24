classdef KalmanEstimator < handle
    %KALMANESTIMATOR discrete adaptive version of kalman estimator
    % source: skripta Stavový model - odhad stavu [František Dušek] 
    % source: http://www.mathworks.com/help/control/ug/kalman-filtering.html#zmw57dd0e24572
    
    properties
        mPlant; % system characteristics
        mQ; % covariance of the output estimation error 
        mR; % covariance of the preprocess estimation error  
        mP; % error covariance matrices
        mx; % internal estimated state
        mk; % internal count of estimation
    end
    
    methods
        function this = KalmanEstimator(A,B,C,D,Q,R,x0)
            this.mPlant = struct();
            this.mPlant.A = A;
            this.mPlant.B = B;
            this.mPlant.C = C;
            this.mPlant.D = D;
            this.mQ = Q;
            this.mR = R;
            this.mP = B*Q*B';
            this.mx = x0;
            this.mk = 1;
        end   

        % update of plant characteristics
        function this = setPlant(this, A, B, C, D)
            this.mPlant.A = A;
            this.mPlant.B = B;
            this.mPlant.C = C;
            this.mPlant.D = D;
        end
        
        % estimation step for uk, yk. Returns estimated > y, x
        function [ye, x] = estimate(this, u, y)
            A=this.mPlant.A; B=this.mPlant.B; C=this.mPlant.C; 
            P=this.mP; x=this.mx; k=this.mk; Nx=size(A,1);
            Q=this.mQ; R=this.mR;
            
            % Measurement update
            L = (P*C')/(C*P*C' + R);        % kalman gain
            x = x + L*(y-C*x);              % x[n|n]
            P = (eye(Nx)-L*C)*P;            % P[n|n]

            ye = C*x; % y = Cx + Du;

            % Time update
            this.mx = A*x + B*u;            % x[n+1|n]
            this.mP = A*P*A' + B*Q*B';      % P[n+1|n]
            this.mk = k+1;
        end
    end
end

