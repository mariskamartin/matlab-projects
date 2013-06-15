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
            value = Criteria.countCriterium((realY-nnY)*(realY-nnY)'/length(realY) , this.countPocetNeuronu(this.net));

            % debug information
%             disp(['log10 z ' num2str((realY-nnY)*(realY-nnY)'/length(realY))]);
            plot(realY); hold on; plot(nnY, 'r'); hold off;
        end
    end
    methods (Static)
        %% zjisti pocet neuronu podle matice biasu
        function n = countPocetNeuronu(net)
            biasArr = net.b;
            n = 0;
            for k = 1:1:length(biasArr)
                [r, s] = size(biasArr{k});
                n = n + r * s;
            end
        end
        %% spocita kriterium na zaklade vstupnich parametru
        function value = countCriterium(sum, num)
            value = log10(sum) + 0.01 * num;
        end
    end
    
end

