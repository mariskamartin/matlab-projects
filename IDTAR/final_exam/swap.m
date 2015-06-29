function [aout] = swap( ain )
%SWAP [1 2 3 4 5] > [5 4 3 2 1]
%   swaps array
    aout = zeros(size(ain));
    aout(end:-1:1) = ain(1:end);
end

