function [ K, l ] = LQoptimise( A, B, C, D, Qn, Qp, Rp, wH)
%LQOPTIMISE Uloha LQ rizeni se sledovanim zadane veliciny na sledovanem horizontu wH.
% Zdroj: skripta LQ - v diskretni oblasti (Frantisek Dusek)
% Pro regulacni zasah plati vztah: u(k)=-K*x(k)+l
% 
% A, B, C, D ... SS popis systemu
% Qn ... penalizace koncoveho stavu
% Q  ... penalizace regulacnich odchylek
% R  ... penalizace akcnich zasahu
% wH ... zadane hodnoty na horizontu [w(k); w(k+1); w(k+2); ...] > verticaly

Nx=size(C,2); %pocet stavu
%zavedeni substituce kvuli sledovani zadane
S=C'*Qp*D;
R=D'*Qp*D+Rp;
Q=C'*Qp*C;
%inicializace
P=Qn;
p=zeros(Nx,1);
%iteracni optimalizace pro wHorizont
for i=length(wH):-1:1
    K=inv(R+B'*P*B)*(S'+B'*P*A);
    l=inv(R+B'*P*B)*(D'*Qp*wH(i,:)-B'*p);
    P=A'*P*A+Q-(S+A'*P*B)*K;                %P(k+1) pro dalsi krok
    p=(A-B*K)'*p-(C-D*K)'*Qp*wH(i,:);
end

