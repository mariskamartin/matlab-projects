classdef Criteria < handle
    %CRITERIA provides seervice to count value of predefined criterium of
    %optimality
    
    properties (Access = private)
        inputs;
        targets;
        net;
    end
    methods
        function [this] = Criteria(net, inputs, targets)
            this.net = net;
            this.inputs = inputs;
            this.targets = targets;
        end
        %% vrati hodnotu kriteria
        function [value] = getValue(this)
            in = this.inputs;
            realY = this.targets;
            %simulate
            nnY = sim(this.net, in);
            %calculate
            value = log10((realY-nnY)*(realY-nnY)'/length(realY)) + 0.1 * this.countPocetNeuronu(this.net);

            % debug information
%             disp(['log10 z ' num2str((realY-nnY)*(realY-nnY)'/length(realY))]);
            plot(realY); hold on; plot(nnY, 'r'); hold off;
        end
    end
    methods (Static, Access = private)
        %% zjisti pocet neuronu podle matice biasu
        function n = countPocetNeuronu(net)
            biasArr = net.b;
            n = 0;
            for k = 1:1:length(biasArr)
                [r, s] = size(biasArr{k});
                n = n + r * s;
            end
        end
    end
    
end

