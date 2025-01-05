clear; close all;

%% Parametry regulatora i modelu

N = 40;
Nu = 5;
lambda = 9;

%% Symulacja działania regulatora

z4_trajektoria_zadana;

[y,u] = z4_gpc_funkcja(N,Nu,lambda,yzad);


%% Wykresy

figure;
plot(u);
xlabel('k');ylabel('u');

figure;hold on;
plot(y); plot(yzad);
xlabel('k');ylabel('y');

E = (yzad - y)*(yzad-y)';
disp(E);