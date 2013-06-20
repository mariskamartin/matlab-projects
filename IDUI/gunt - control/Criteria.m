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
            t = 0:0.75:(0.75*length(in)-0.5);
            plot(t,realY); hold on; plot(t,nnY, 'r'); hold off;
            legend('u reálný','u inverze');
            xlabel('Èas');
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

