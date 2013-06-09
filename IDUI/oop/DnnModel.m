classdef DnnModel < handle
    %DNNMODEL je trida pro vytvoreni dynamickeho neuronoveho modelu
    
    properties (Access = private)
        %% dynamicky neuronovy model soustavy
        net;
        %% vysledky trenovani net
        trainResults;
        %% pamet na vstupy u
        uMemory;
        %% pamet na vystupy y
        yMemory;
        %% vstupy a cile pri uceni
        learnInputs;
        learnTargets;
    end
    
    methods
        %% konstruktor - umi nacist i ze souboru
        function [this] = DnnModel(filePath)
            if(nargin == 1)
                this.loadFromBackup(filePath); 
                disp(['instance is loaded from ' filePath]);
            end
        end
        
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
            this.net.divideParam.trainRatio = 80/100;
            this.net.divideParam.valRatio = 10/100;
            this.net.divideParam.testRatio = 10/100;
            % nezobrazovat okno uceni
            this.net.trainParam.showWindow = false;
            if(nargin == 5)
                this.net.trainParam.time = maxTrainTime;
                this.net.trainParam.epochs = 200;
                this.net.trainParam.max_fail = 1000;
            end
            % Train the Network
            [this.net, this.trainResults] = train(this.net, inputs, targets);
        end
        %% nauci se optimalizovane aproximovat predane hodnoty
        function learnOptimized(this, inputs, targets)
            startTime = now();
            topologyPatterns = {10; 12; 15; 20; [8 8]; [5 5]}; %[11 15 18 20 25]; %[11 15 18 20 22 25 29];
            replications = 5;
            count = 1; 
            optimizedTopology = cell(replications*length(topologyPatterns),1);
            for k = 1:length(topologyPatterns)
                for j = 1:replications
                    optimizedTopology{count} = topologyPatterns{k};
                    count = count + 1;
                end
            end
            maxTrainTimeInSec = 30;
            performance = ones(length(optimizedTopology), 1).*99;
            optimizeData = cell(length(optimizedTopology), 2);
            %vyrobit slozku pro vysledky
            mkdir(DnnModel.getDirName(startTime));
            %vlastni cyklus pro uceni a ukladani nejlepsich vysledku
            for k = 1:length(optimizedTopology)
                this.learn(inputs, targets, optimizedTopology{k}, maxTrainTimeInSec);
                % vyhodnotit a pripadne spustit znovu
                simplefitOutputs = sim(this.net, this.learnInputs);
                actPerformance = perform(this.net,this.learnTargets,simplefitOutputs); %minimalizujeme
                disp([num2str(k) '. info top/regress/perf [' num2str(optimizedTopology{k}) ', ' num2str(actPerformance) ']']);
                if(actPerformance < min(performance)) 
                    OopHelper.serialize([DnnModel.getDirName(startTime) '/' DnnModel.getFileName(k)], this);
                    disp('> model saved...');
                end
                performance(k) = actPerformance;
                optimizeData{k,1} = num2str(optimizedTopology{k});
                optimizeData{k,2} = actPerformance;
            end
            OopHelper.serialize([DnnModel.getDirName(startTime) '/measureInfo'], optimizeData); disp('info data saved...');
            [~, idx] = min(performance); disp(['best model is at ' num2str(idx)]);
            %nahrat ze zalohy nejlepsi pokus
            this.loadFromBackup([DnnModel.getDirName(startTime) '/' DnnModel.getFileName(idx)]); disp('best model loaded...');
        end
        %% nacte se instance serializovana v zaloznim souboru
        function loadFromBackup(this, fileName)
            disp('loading from backup...');
            backup = OopHelper.deserialize(fileName);
            this.net = backup.net;
            this.trainResults = backup.trainResults;
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
        %% vrati uvnitr ulozenou neutonovou sit
        function net = getNet(this)
            net = this.net;
        end
    end
    methods(Static, Access = private)
        function dirName = getDirName(datum)
            if(nargin < 1)
                datum = now();
            end
            dirName = ['cache_' datestr(datum,'yyyy-mm-dd_HHMMss')];
        end
        function fileName = getFileName(number)
            fileName = ['modelSave' num2str(number)];
        end
    end
end

