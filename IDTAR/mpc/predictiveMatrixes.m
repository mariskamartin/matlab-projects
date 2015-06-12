function [Syx, Syu, Sxx, Sxu] = predictiveMatrixes(A,B,C,N)
%PREDICTIVEMATRIXES creates predictive matrixes 
% A,B,C ... system characteristics
% N     ... number of see-ahead ()

Sxx = A^N;
for n = 1:N
    Sxu(:,n) = A^(N-n)*B; 
    Syx(n,:) = C*A^n; 
end

for n=0:N-1
    for i=1:N
        if (i+n <= N) 
            Syu(i+n,i) = C*A^n*B; 
        end
    end
end



