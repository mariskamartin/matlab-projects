classdef PIDreg < handle
    properties
        P
        I
        D
        sumE
        eLast
        Ts
    end
    methods
        function this = PIDreg(P,I,D,Ts)
            this.P = P;
            this.I = I;
            this.D = D;
            this.Ts = Ts;
            this.eLast = 0;
            this.sumE = 0;
        end
        function u = evalControlAction(this, w, y)
            e = w - y;
            this.sumE = this.sumE + e;
            u = this.P*e + this.I*this.sumE*this.Ts + this.D*(e - this.eLast)/this.Ts;
            this.eLast = e;
        end
    end
end

