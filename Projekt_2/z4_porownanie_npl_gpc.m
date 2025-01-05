clear; close all;

%% Parametry regulatora

N = 40;
Nu = 5;
lambda = 9;

% model do GPC


%% Symulacja działania regulatora
z4_trajektoria_zadana;

[y_NPL,u_NPL] = z4_npl_funkcja(N,Nu,lambda, yzad);

[y_GPC,u_GPC] = z4_gpc_funkcja(N,Nu,lambda, yzad);


%% Wykresy
figure;hold on; grid on; grid minor;
plot(u_NPL);plot(u_GPC);
xlabel('k');ylabel('u');

figure;hold on;grid on; grid minor;
plot(y_NPL); plot(y_GPC);stairs(yzad);
xlabel('k');ylabel('y');

E = (yzad - y_NPL)*(yzad-y_NPL)';
disp(E);

E = (yzad - y_GPC)*(yzad-y_GPC)';
disp(E);