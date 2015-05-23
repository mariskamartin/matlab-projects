classdef Motor < handle
    %MOTOR - demonstrative system for control
    properties (SetAccess = private)
        J;
        b;
        K;
        R;
        L;
        
        A;
        B;
        C;
        D;
    end
    properties (Access = private)
        transferFunction;
    end    
    
    methods
        
        % konstruktor motoru
        function this = Motor()
            this.J=0.01;
            this.b=0.1;
            this.K=0.01;
            this.R=1;
            this.L=0.5;

            this.A=[-this.b/this.J   this.K/this.J;
                    -this.K/this.L   -this.R/this.L];
            this.B=[0;
                    1/this.L];
            this.C=[1   0];
            this.D=0;
            
            this.transferFunction = tf(ss(this.A,this.B,this.C,this.D));
        end
        
        function transFunc = getTF(this)
            transFunc = this.transferFunction; 
        end
    end
    
end

