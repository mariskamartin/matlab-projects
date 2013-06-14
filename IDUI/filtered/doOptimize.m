% script for discover optimal dynamic neural modelo of motor

% keep for all test value of criteria, performance, ...
% for each topology do 5 tests
% save better model tagged with criteria value.. 

inputs = inputs;
targets = targets;
startTime = now();
topologyPatterns = {5; 8; 10; [4 4]; [5 5]}; % 15; 20; [8 8]; [5 5]  [11 15 18 20 25]; %[11 15 18 20 22 25 29];
replications = 5;
maxTrainTimeInSec = 1*60;
count = 1; 
optimizedTopology = cell(replications*length(topologyPatterns),1);
for k = 1:length(topologyPatterns)
    for j = 1:replications
        optimizedTopology{count} = topologyPatterns{k};
        count = count + 1;
    end
end
criterias = ones(length(optimizedTopology), 1).*99;
optimizeData = cell(length(optimizedTopology), 2);
%vyrobit slozku pro vysledky
folderName = ['vysledky_' datestr(startTime,'yyyy-mm-dd_HHMMss')];
mkdir(folderName);

%vlastni cyklus pro uceni a ukladani nejlepsich vysledku
for k = 1:length(optimizedTopology)
    [net, trainResults] = learnNet(inputs, targets, optimizedTopology{k}, maxTrainTimeInSec);
    % vyhodnotit a pripadne spustit znovu
    crit = Criteria(net, inputs, targets); 
    critValue = crit.getValue(); %[minimalizujeme]
    simplefitOutputs = net(inputs);
    actPerformance = perform(net, targets, simplefitOutputs);
    disp([num2str(k) '. top/perf/criteria [' num2str(optimizedTopology{k}) ', ' num2str(actPerformance) ', ' num2str(critValue) ']']);
    if(critValue < min(criterias)) 
        save([folderName '/workspace_' num2str(critValue) '.mat']); 
        disp('> model saved...');
    end
    criterias(k) = critValue;
    optimizeData{k,1} = num2str(optimizedTopology{k});
    optimizeData{k,2} = actPerformance;
    optimizeData{k,3} = critValue;
    optimizeData{k,4} = trainResults.perf;
    save([folderName '/measureInfo'], 'optimizeData'); 
    disp('> info data saved...');
end
[~, idx] = min(criterias); 
disp(['best model is at ' num2str(idx)]);
