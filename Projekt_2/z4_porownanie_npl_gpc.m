clear; close all;

%% Parametry regulatora

N = 40;
Nu = 5;
lambda = 3000; % 9 3000

% model do GPC


%% Symulacja działania regulatora
z4_trajektoria_zadana;

[y_NPL,u_NPL] = z4_npl_funkcja(N,Nu,lambda, yzad);

[y_GPC,u_GPC] = z4_gpc_funkcja(N,Nu,lambda, yzad);


%% Wykresy
colors = lines(3);
figure;hold on; grid on; grid minor;
plot(u_NPL,LineWidth=1);plot(u_GPC, LineWidth=0.01);
xlabel('k');ylabel('u');
legend('NPL', 'GPC', Location='best');
exportgraphics(gcf, 'Wykresy/z4_npl_gpc_por_u.pdf', 'ContentType', 'vector');


figure;hold on;grid on; grid minor;
stairs(yzad,'--',LineWidth=1, Color=colors(3,:)); plot(y_NPL,LineWidth=1, Color=colors(1,:)); plot(y_GPC, Color=colors(2,:));
xlabel('k');ylabel('y');
legend('y_{zad}', 'NPL', 'GPC', Location='south');
exportgraphics(gcf, 'Wykresy/z4_npl_gpc_por_y.pdf', 'ContentType', 'vector');

E = (yzad - y_NPL)*(yzad-y_NPL)';
disp(E);

E = (yzad - y_GPC)*(yzad-y_GPC)';
disp(E);