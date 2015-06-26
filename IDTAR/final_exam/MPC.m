classdef MPC < handle
    % MPC discrete controller
    % source: skripta Prehled prediktivniho rizeni [František Dušek] 
    
    properties
        mPlant; % system characteristics
        mQn; % end state penalization
        mQ; % state penalization
        mR; % control action penalization
        mWn; % horizont / ahead count
        mv;  %member struct values
        mConstraints; %member struct constraints
    end
    
    methods
        function this = MPC(A,B,C,D,Qn, Q,R,wn)
            this.mPlant = struct();
            this.mPlant.A = A;
            this.mPlant.B = B;
            this.mPlant.C = C;
            this.mPlant.D = D;
            this.mQ = Q;
            this.mQn = Qn;
            this.mR = R;
            this.mWn = wn;
            this.mv = struct(); 

            [Syx,Syu,Sxx,Sxu] = MPC.predictiveMatrixes(A,B,C,wn);
            Zx = inv(eye(length(A))-A)*B;
            Zxy = Zx*inv(C*Zx+D);
            M = R+Syu'*Q*Syu+Sxu'*Qn*Sxu;
            un0=zeros(wn,1);
            
            this.mv.Syx = Syx;
            this.mv.Syu = Syu;
            this.mv.Sxx = Sxx;
            this.mv.Sxu = Sxu;
            this.mv.Zx = Zx;
            this.mv.Zxy = Zxy;
            this.mv.M = M;
            this.mv.un0 = un0;
            
            this.mConstraints = struct();
            this.mConstraints.isEnabled = false;
            this.mConstraints.qA = [eye(wn); -eye(wn)];
            this.mConstraints.optimizeConf = optimset('Algorithm','active-set','LargeScale','off','Display','off'); %parametry pro ompitmalizaci v quadprog;
        end   
        
        %evalControlAction Evaluate control action for actual x and horizont wH.
        % x  ... state
        % wH ... reference values at horizont [0,0,0,0,1,1,1,1]
        function [uk] = evalControlAction(this, x, wH)
            Q=this.mQ; Qn=this.mQn;
            v = this.mv; c = this.mConstraints;
            
            v.un0=[v.un0(2:end); v.un0(end)]; %shift minulych hodnot
            dxn=v.Zxy*wH(end)-v.Sxx*x-v.Sxu*v.un0;
            dwn=wH-v.Syx*x-v.Syu*v.un0;
            m=-(v.Sxu'*Qn*dxn+v.Syu'*Q*dwn);
            if c.isEnabled 
                %vypocet s omezeni
                qb = [c.uMax-v.un0; v.un0-c.uMin];
                du = quadprog(v.M, m, c.qA, qb,[],[],[],[],[],c.optimizeConf);
            else
                %analiticke reseni  
                du=-v.M\m; 
            end
            v.un0=v.un0+du; %aktualizace pro dalsi kolo 
            uk=v.un0(1);
        end
        
        %setInputMinMax creates restrictions for input values
        % minU ... minimum input value
        % maxU ... maximum input value
        function setInputMinMax(this, minU, maxU)
            this.mConstraints.isEnabled = true;
            this.mConstraints.uMax = maxU;
            this.mConstraints.uMin = minU;
        end
        
    end
    
    methods (Static)
        %PREDICTIVEMATRIXES creates predictive matrixes 
        % A,B,C ... system characteristics
        % N     ... number of see-ahead ()
        function [Syx, Syu, Sxx, Sxu] = predictiveMatrixes(A,B,C,N)
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

