crit = Criteria(net, inputs, targets);
c = crit.getValue();
save(['workspace_' num2str(c) '.mat']); 


if(exist('informations.mat','file') == 0)
    info = [];
    save('informations.mat', 'info');
end

l = load('informations.mat');
info = l.info;
l = length(info)+1;
info{l, 1} = num2str(topology);
info{l, 2} = c;
info{l, 3} = tr.perf;
info{l, 4} = tr.tperf;



