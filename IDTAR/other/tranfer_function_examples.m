clear, clc;
TF = tf([1 1],[1 0])
step(TF);

figure;
TF = tf([0 1],[1 1])
step(TF);

figure;
TF = tf([1 1],[1 1])
step(TF);

figure;
TF = tf([0 1],[1 1 1])
step(TF);

figure;
TF = tf([0 1],[1 1 1 1])
step(TF);
