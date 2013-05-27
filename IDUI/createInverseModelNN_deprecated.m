
%creates inputs
inputs = [sim_y(3:end)'; sim_y(2:end-1)'; sim_y(1:end-2)'; sim_u(1:end-2)'];
%creates targets
targets = sim_u(2:end-1)';

%create NN
nnet = newff(inputs, targets, 15);
%train net
[nnet, tr] = train(nnet, inputs, targets);
%generate simulink block
gensim(nnet, 0.1);
