classdef DnnModel < handle
    %DNNMODEL je trida pro vytvoreni dynamickeho neuronoveho modelu
    
    properties (Access = private)
        %% dynamicky neuronovy model soustavy
        net;
        %% pamet na vstupy u
        uMemory;
        %% pamet na vystupy y
        yMemory;
        %% vstupy a cile pri uceni
        learnInputs;
        learnTargets;
    end
    
    methods
        %% nauci se aproximova predane vstupy a vystupy
        function learn(this, inputs, targets, topology, maxTrainTime)
            % povinne jsou prvni dva argumenty "inputs, targets"
            
            this.learnInputs = inputs;
            this.learnTargets = targets;
            % Create a Fitting Network
            if(nargin < 4) 
                topology = 20; 
            end 
            hiddenLayerSize = topology;
            clear('this.net');
            this.net = fitnet(hiddenLayerSize);
            % Setup Division of Data for Training, Validation, Testing
            this.net.divideParam.trainRatio = 75/100;
            this.net.divideParam.valRatio = 10/100;
            this.net.divideParam.testRatio = 15/100;
            % nezobrazovat okno uceni
            this.net.trainParam.showWindow = false;
            if(nargin == 5)
                this.net.trainParam.time = maxTrainTime;
            end
            % Train the Network
            [this.net, ~] = train(this.net, inputs, targets);
            %simulovat hodnoty
%             simplefitOutputs = sim(this.net, inputs);
            %spocitat regresi
%             [r, ~, ~] = regression(targets, simplefitOutputs);
            %zobrazit regresi
%             plotregression(targets,simplefitOutputs);    
            
%             if(r > 0.99996)
%                 disp('regression is OK');
%             else
%                 disp('regression is BAD');
%             end            
        end
        %% nauci se optimalizovane aproximovat predane hodnoty
        function learnOptimized(this, inputs, targets)
            topologyPatterns = [11 15 18 20 22 25 29];
            replications = 10;
            optimizedTopology = topologyPatterns(1)*ones(replications,1);
            for k = topologyPatterns(2:end)
                optimizedTopology = [optimizedTopology; k*ones(replications,1)];
            end
            maxTrainTimeInSec = 30;
            performance = ones(length(optimizedTopology), 1).*99;
            optimizeData = zeros(length(optimizedTopology), 2);
            mkdir(DnnModel.getDirName());
            %vlastni cyklus pro uceni a ukladani nejlepsich vysledku
            for k = 1:length(optimizedTopology)
                this.learn(inputs, targets, optimizedTopology(k), maxTrainTimeInSec);
                % vyhodnotit a pripadne spustit znovu
                simplefitOutputs = sim(this.net, this.learnInputs);
                [r, ~, ~] = regression(this.learnTargets, simplefitOutputs); %maximalizujeme
                actPerformance = perform(this.net,this.learnTargets,simplefitOutputs); %minimalizujeme
                disp([num2str(k) '. info top/regress/perf [' num2str(optimizedTopology(k)) ', ' num2str(r) ', ' num2str(actPerformance) ']']);
                if(actPerformance < min(performance)) 
                    OopHelper.serialize(DnnModel.getFileName(k), this);
                    disp('> model saved...');
                end
                performance(k) = actPerformance;
                optimizeData(k,1) = optimizedTopology(k);
                optimizeData(k,2) = actPerformance;
            end
            OopHelper.serialize([DnnModel.getDirName() '/measureInfo'], optimizeData); disp('info data saved...');
            [~, idx] = min(performance); disp(['best model is at ' num2str(idx)]);
            %nahrat ze zalohy nejlepsi pokus
            this.loadFromBackup(DnnModel.getFileName(idx)); disp('best model loaded...');
        end
        %% nacte se instance serializovana v zaloznim souboru
        function loadFromBackup(this, fileName)
            disp('loading from backup...');
            backup = OopHelper.deserialize(fileName);
            this.net = backup.net;
            this.uMemory = backup.uMemory;
            this.yMemory = backup.yMemory;
            this.learnInputs = backup.learnInputs;
            this.learnTargets = backup.learnTargets;            
        end
        %% zobrazi graf regrese pro tento dnn
        function showRegression(this)
            %simulovat hodnoty
            simplefitOutputs = sim(this.net, this.learnInputs);
            %zobrazit regresi
            plotregression(this.learnTargets, simplefitOutputs);    
        end
        %% inicializuje system na pocatecni podminky
        function initSystem(this, radSoustavy)
            %inicializuji vychozi hodnoty na -1, protoze hodnoty mame normalizovane na
            %interval <-1 , 1>
            this.uMemory = zeros(radSoustavy, 1) + (-1);
            this.yMemory = zeros(radSoustavy, 1) + (-1);
        end
        %% simuluje odezvu na vstupni hodnotu dle interni DNS
        function [y] = simulate(this, u)
                this.uMemory(1) = u;
                y = sim(this.net, [this.yMemory; this.uMemory]);
                %posun hodnot v pameti
                this.yMemory(2:end) = this.yMemory(1:end-1);
                this.yMemory(1) = y;
                this.uMemory(2:end) = this.uMemory(1:end-1);
        end
    end
    methods(Static, Access = private)
        function dirName = getDirName()
            dirName = ['cache_' date()];
        end
        function fileName = getFileName(number)
            fileName = [DnnModel.getDirName() '/modelSave' num2str(number)];
        end
    end
end

