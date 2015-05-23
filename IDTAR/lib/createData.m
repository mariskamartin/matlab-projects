function [ data ] = createData( sampleData, lengthOfSample )
%CREATEDATA Summary of this function goes here
%   Detailed explanation goes here
    data = [];
    for d = sampleData
        data = [data ones(1, lengthOfSample)*d];
    end
end

