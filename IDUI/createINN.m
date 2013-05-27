function [ nnet ] = createINN(sim_y, sim_u, hiddenNeuronsTopology)
%CREATEINN vyrobi neuronovou sit pro nasnimana data ze simulinku a zaroven
% vygeneruje simulacni blok pokud je dostatecne uspesne trenovani site
%   example:  nnet = createINN(sim_y, sim_u, [15], Ts);

    %creates inputs
    inputs = [sim_y(3:end)'; sim_y(2:end-1)'; sim_y(1:end-2)'; sim_u(1:end-2)'];
    %creates targets
    targets = sim_u(2:end-1)';

    disp('creating NN...');
    nnet = newff(inputs, targets, hiddenNeuronsTopology);
    disp('training...');
    [nnet, tr] = train(nnet, inputs, targets);
    if(tr.gradient(end) < 0.0001)
        %generate simulink block
%         disp('Generating simulink model');
%         gensim(nnet, sampleTime);
    end
end

