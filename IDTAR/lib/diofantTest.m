A = [1 3 5];
B = [1 5];
C = [1 5 6];

%resi diofanticke rovnice
%[X, Y] = dio(A, B, C);
[X, Y] = diofant(A, B, C);
zkouska = conv(A, X) + conv([0 B], Y); %zkouska - musi to vyjit stejne jako C
assert(isequal(rpad(C,length(zkouska)),int32(zkouska)), '1.');

%% priklad 2 s MOTOREM, kde pro 1.rad nema reseni > X = [0 0]
B = [0 2];
A = [1 12 20.02];
C = [1 3]; %pole (s + 3)

%resi diofanticke rovnice
[X, Y] = diofant(A, B, C);
zkouska = conv(A, X) + conv([0 B], Y); %zkouska - musi to vyjit stejne jako C
assert(isequal(rpad(C,length(zkouska)),zkouska), '2.');

%% priklad 2 s MOTOREM pro 2.rad
B = [0 2];
A = [1 12 20.02];
C = [1 5 6]; %poles (s + 3)(s + 2)

%resi diofanticke rovnice
[X, Y] = diofant(A, B, C);
zkouska = conv(A, X) + conv([0 B], Y); %zkouska - musi to vyjit stejne jako C
assert(isequal(rpad(C,length(zkouska)),zkouska), '3.');

