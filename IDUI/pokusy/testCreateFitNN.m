load data;
trimCount = 5000; %omezeni dat
t=data.signals.values(1:trimCount,1)'; %t,u,y .. radkove vektory
u=data.signals.values(1:trimCount,2)';
y=data.signals.values(1:trimCount,3)';

    %VARIANTA 1
    %creates inputs
    inputs = [y(2:end-1); y(1:end-2); u(2:end-1); u(1:end-2)];
    %creates targets
    targets = y(3:end);
    % Create a Fitting Network
    hiddenLayerSize = 20;
    net = fitnet(hiddenLayerSize);
    % Setup Division of Data for Training, Validation, Testing
    net.divideParam.trainRatio = 75/100;
    net.divideParam.valRatio = 10/100;
    net.divideParam.testRatio = 15/100;
    % nezobrazovat okno uceni
    net.trainParam.showWindow = false;
    % Train the Network
    [net,tr] = train(net,inputs,targets);
    
    %zobrazit regresi
    simplefitOutputs = sim(net,inputs);
    plotregression(targets,simplefitOutputs);    
    [r,m,b] = regression(targets, simplefitOutputs);
    if(r > 0.99996)
        disp('network is OK')
    end
%     save net;
%     clear net;
    %VARIANTA 2
%     mnet = createNNModel(u, y);
%     save mnet;
%     clear mnet;