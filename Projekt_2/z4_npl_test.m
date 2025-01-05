% clear; close all;

%% Parametry regulatora

N = 40;
Nu = 5;
lambda = 9;
% load("modele\sieci\model_K6_alg_BFGS_tryb_OE.mat"); % w10, w1, w20, w2

%% Symulacja działania regulatora
z4_trajektoria_zadana;

[y,u] = z4_npl_funkcja(N,Nu,lambda, yzad);

%% Wykresy
figure;
plot(u);
xlabel('k');ylabel('u');

figure;hold on;
plot(y); stairs(yzad);
xlabel('k');ylabel('y');

E = (yzad - y)*(yzad-y)';
disp(E);