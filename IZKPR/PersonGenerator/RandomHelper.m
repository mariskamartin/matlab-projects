classdef RandomHelper
    %RANDOMHELPER pomocna trida pro generovani nahodnych cisel
    methods (Access = private)
        function [this] = RandomHelper()
            %library pattern (nelze vytvaret instance teto tridy)
            %zverejnuje pouze staticke metody
        end
    end
    
    methods (Static)
        %% Generuje realna cisla v intervalu od do (from, to), Uniform distribution
        function [value] = nextFromTo(from, to)
            value = from + (to-from).*rand();
        end
        %% Generuje cela cisla v intervalu od do (from, to), Uniform distribution
        function [value] = nextIntegerFromTo(from, to)
            value = randi([from, to]);
        end
        %% Generuje unikatni identifikator
        function [uuid] = nextUUID()
            uuid = char(java.util.UUID.randomUUID.toString());
        end
    end
    
end

