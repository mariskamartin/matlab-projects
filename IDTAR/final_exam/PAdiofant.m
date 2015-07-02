function [ Q, P, R ] = PAdiofant( A, B, C, isDiscreete)
%DIOFANT ... searching solution for diophantic polynomial inputs for equotation AX + BY = C
% A,B,C ... horizontal vectors
% returns Q,P ... horizontal vectors
% return R ... horiz. vector
% for:
%          | R |          | B |
%  w ----->| - |---->X--->| - | ------*----> y
%          | Q |     |    | A |       |
%                    |                |
%                    |    | P |       |
%                    *----| - | ------*
%                         | Q |

    l = [length(C)-length(B) length(A)-1];
    % nx = length(B) - 1; %rad polynomu X
    ny = l((length(C) < (length(A) + length(B))) + 1); 

    M = sylvester(A, B);
    C = prepareSolutionVector(M, C);
    solution = M\C; %inv(M)*C; .. performance
    if norm(M*solution-C) > 0.001 % if this is zero or very small, we have a solution
        error('solutioin NOT exists');
    end
    
    Q = solution(1:end-ny)';
    P = solution(end-ny+1:end)';
    % R - je zesileni ktere v ustalenem stavu musi byt rovno zadane
    % velicine.
    if isDiscreete
        % pro diskretni variantu je to sum(C)/sum(B)
        R = sum(C)/sum(B);
    else
        % pro spojitou variantu je to b0/a0
        R = C(end)/B(end);
    end
end



%% Creates Silvestr's matrix
function M = sylvester(prenosJmenovatel,prenosCitatel)
    num_n = length(prenosJmenovatel)-1;
    num_m = length(prenosCitatel);

    % Ensure B is a row vector
    siz = size(prenosCitatel);
    if siz(1)>siz(2)
        prenosCitatel = prenosCitatel';
    end

    % pad B with zeros to have same length as A
    prenosCitatel = [zeros(1,num_n+1-num_m) prenosCitatel];
    M = zeros(2*num_n);

    % Main "algorithm"
    for i = 1:num_n
        for j = 1:num_n+1
            % populate left side
            M(j+i-1,i) = prenosJmenovatel(j);
            % populate right side
            M(j+i-1,i+num_n) = prenosCitatel(j);
        end
    end
end

%% Prepate solution vector for b = inv(A) * x
function out = prepareSolutionVector(A, x)
    % pad x with zeros from right side
    out = [x zeros(1,length(A)-length(x))];
    % transpose
    out = out';
end

%LPAD padd vector to length with zeros
function [ leftPadded ] = lpad( vector, outLength )
    leftPadded = [zeros(1,outLength - length(vector)) vector];
end
