% Parametry regulatora
N = 50;
Nu = 5;
lambda = 15;
load("modele\sieci\model_K6_alg_BFGS_tryb_OE.mat"); % w10, w1, w20, w2

% Symulacja działania regulatora
z4_trajektoria_zadana;

umin = -1;
umax = 1;
dumult = 1;

% Tworzenie folderu wyników, jeśli nie istnieje
folder_wyniki = fullfile('Wykresy', 'NO');

[y_NO, u_NO, E_NO] = regulator_NO(N, Nu, lambda, ...
    umin, umax, dumult, yzad, w10, w1, w20, w2);

[y_NPL, u_NPL] = z4_npl_funkcja(N, Nu, lambda, yzad);


dumax = umax - umin;

% Tworzenie wykresów sterowania
figure;
hold on;
plot(u_NO, '-', DisplayName='NO');
plot(u_NPL, '--', DisplayName='NPL');
xlabel('k'); ylabel('u');
title('Sterowanie - Porównanie NO i NPL');
legend('Location', 'best');
grid on; grid minor;
exportgraphics(gcf, fullfile(folder_wyniki, 'NO_NPL_u_por.pdf'), 'ContentType', 'vector');
close;

% Tworzenie wykresów wyjścia
figure;
hold on;
plot(y_NO, '-', DisplayName='NO');
plot(y_NPL, '--', DisplayName='NPL');
stairs(yzad, '-.', 'DisplayName', 'y_{zad}');
xlabel('k'); ylabel('y');
title('Wyjście - Porównanie NO i NPL');
legend('Location', 'southeast');
grid on; grid minor;
exportgraphics(gcf, fullfile(folder_wyniki, 'NO_NPL_y_por.pdf'), 'ContentType', 'vector');
close;
