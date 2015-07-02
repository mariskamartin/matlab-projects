function [ rightPadded ] = rpad( vector, outLength )
%LPAD padd vector to length with zeros
    rightPadded = [vector zeros(1,outLength - length(vector))];
end

