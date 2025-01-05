clear; close all;

%% Parametry regulatora i modelu

N = 80;
Nu = 5;
lambda = 9;

b(5) = 0.0981;
b(6) = -0.0929;
a(1) = -1.9199;
a(2) = 0.9220;

% do wygodnego wykorzystania w równaniu różnicowym
w = [b(5);b(6);-a(1);-a(2)];

%% Symulacja działania regulatora

z4_trajektoria_zadana;

[y,u] = z4_gpc_funkcja(N,Nu,lambda,b,a,w,yzad);


%% Wykresy

figure;
plot(u);
xlabel('k');ylabel('u');

figure;hold on;
plot(y); plot(yzad);
xlabel('k');ylabel('y');

E = (yzad - y)*(yzad-y)';
disp(E);