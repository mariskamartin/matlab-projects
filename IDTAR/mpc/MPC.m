classdef MPC < handle
    % MPC discrete controller
    % source: skripta Prehled prediktivniho rizeni [František Dušek] 
    
    properties
        mPlant; % system characteristics
        mQ; % covariance of the output estimation error 
        mR; % covariance of the preprocess estimation error  
        mWn; % horizont ahead count
    end
    
    methods
        function this = MPC(A,B,C,D,Q,R,wn)
            this.mPlant = struct();
            this.mPlant.A = A;
            this.mPlant.B = B;
            this.mPlant.C = C;
            this.mPlant.D = D;
            this.mQ = Q;
            this.mR = R;
            this.mWn = wn;
        end   

        % update of plant characteristics
        function this = setPlant(this, A, B, C, D)
            this.mPlant.A = A;
            this.mPlant.B = B;
            this.mPlant.C = C;
            this.mPlant.D = D;
        end
        
        % estimation step for uk, yk. Returns estimated > y, x
        function [ye, x] = evalControlAction(this, u, y)
            A=this.mPlant.A; B=this.mPlant.B; C=this.mPlant.C; 
            Q=this.mQ; R=this.mR; wn=this.mWn;
            Nx=size(A,1);
            

        end
        
        function [Syx, Syu, Sxx, Sxu] = predictiveMatrixes(A,B,C,N)
            %PREDICTIVEMATRIXES creates predictive matrixes 
            % A,B,C ... system characteristics
            % N     ... number of see-ahead ()
            Sxx = A^N;
            for n = 1:N
                Sxu(:,n) = A^(N-n)*B; 
                Syx(n,:) = C*A^n; 
            end

            for n=0:N-1
                for i=1:N
                    if (i+n <= N) 
                        Syu(i+n,i) = C*A^n*B; 
                    end
                end
            end        
        end
    end
end

