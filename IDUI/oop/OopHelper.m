classdef OopHelper
    methods (Static)
        %% ulozi do souboru objekt
        function serialize(fileName, object)
%             assignin('base', 'pomFileVariable', object);
            pomFileVariable = object;
            save(fileName, 'pomFileVariable');
            clear('pomFileVariable');
        end
        %% nahraje ze souboru objekt
        function object = deserialize(fileName)
            loadedStruct = load(fileName);
            object = loadedStruct.pomFileVariable;
        end
    end
    
    methods (Access = private)
        function this = OopHelper()
            % knihovni trida
        end
    end
    
end

