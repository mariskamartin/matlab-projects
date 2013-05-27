function createMdlNN(nnet, sampleTime)
%CREATEINN vyrobi simulinkovou neuronovou sit pro NN objekt
    %generate simulink block
    disp('Generating simulink model');
    gensim(nnet, sampleTime);
end

