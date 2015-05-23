function [ leftPadded ] = lpad( vector, outLength )
%LPAD padd vector to length with zeros
    leftPadded = [zeros(1,outLength - length(vector)) vector];
end

