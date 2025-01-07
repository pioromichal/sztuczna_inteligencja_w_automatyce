% Parametry regulatora
N = 50;
Nu = 5;
lambda = 15;
load("modele\sieci\model_K6_alg_BFGS_tryb_OE.mat"); % w10, w1, w20, w2

% Symulacja działania regulatora
z4_trajektoria_zadana;

umin = -1;
umax = 1;
dumult = [1, 0.5, 0.2, 0.1,0.05];
dumax = umax-umin;
% Tworzenie folderu wyników, jeśli nie istnieje
folder_wyniki = fullfile('Wykresy', 'NO');

% Symulacja dla każdej wartości dumult
for i = 1:length(dumult)
    [y, u, E] = regulator_NO(N, Nu, lambda, ...
        umin, umax, dumult(i), yzad, w10, w1, w20, w2);
    y_wszystkie{i} = y;  % Zapisanie wyników wyjścia
    u_wszystkie{i} = u;  % Zapisanie wyników sterowania
    E_wszystkie(i) = E; % Zapisanie błędu
end

%% Indeksy dla dwóch grup
indeks_grupa1 = [1, 2, 3]; % Pierwsze trzy wartości dumult
indeks_grupa2 = [3, 4, 5]; % Ostatnie trzy wartości dumult (wspólny środkowy)
dumax = umax-umin;
% Definicja stylów linii
style_linii = {'-', '--', '-.', ':'};

% Tworzenie wykresów sterowania
figure;
hold on;
for j = 1:length(indeks_grupa1)
    i = indeks_grupa1(j);
    plot(u_wszystkie{i}, style_linii{mod(j - 1, length(style_linii)) + 1}, ...
        'DisplayName', sprintf('|\\Delta u_{ogr}| = %.2f', dumult(i)*dumax));
end
xlabel('k'); ylabel('u');
title('Sterowanie - Grupa 1');
legend('Location', 'best');
grid on; grid minor;
exportgraphics(gcf, fullfile(folder_wyniki, 'NO_u_grupa1.pdf'), 'ContentType', 'vector');
close;

figure;
hold on;
for j = 1:length(indeks_grupa2)
    i = indeks_grupa2(j);
    plot(u_wszystkie{i}, style_linii{mod(j - 1, length(style_linii)) + 1}, ...
        'DisplayName', sprintf('|\\Delta u_{ogr}| = %.2f', dumult(i)*dumax));
end
xlabel('k'); ylabel('u');
title('Sterowanie - Grupa 2');
legend('Location', 'best');
grid on; grid minor;
exportgraphics(gcf, fullfile(folder_wyniki, 'NO_u_grupa2.pdf'), 'ContentType', 'vector');
close;

% Tworzenie wykresów wyjścia
figure;
hold on;
for j = 1:length(indeks_grupa1)
    i = indeks_grupa1(j);
    plot(y_wszystkie{i}, style_linii{mod(j - 1, length(style_linii)) + 1}, ...
        'DisplayName', sprintf('|\\Delta u_{ogr}| = %.2f', dumult(i)*dumax));
end
stairs(yzad, '--', 'DisplayName', 'y_{zad}');
xlabel('k'); ylabel('y');
title('Wyjście - Grupa 1');
legend('Location', 'southeast');
grid on; grid minor;
exportgraphics(gcf, fullfile(folder_wyniki, 'NO_y_grupa1.pdf'), 'ContentType', 'vector');
close;

figure;
hold on;
for j = 1:length(indeks_grupa2)
    i = indeks_grupa2(j);
    plot(y_wszystkie{i}, style_linii{mod(j - 1, length(style_linii)) + 1}, ...
        'DisplayName', sprintf('|\\Delta u_{ogr}| = %.2f', dumult(i)*dumax));
end
stairs(yzad, '--', 'DisplayName', 'y_{zad}');
xlabel('k'); ylabel('y');
title('Wyjście - Grupa 2');
legend('Location', 'southeast');
grid on; grid minor;
exportgraphics(gcf, fullfile(folder_wyniki, 'NO_y_grupa2.pdf'), 'ContentType', 'vector');
close;

% Wyświetlenie błędów
for i = 1:length(dumult)
    fprintf('dumult = %.2f, E = %.4f\n', dumult(i), E_wszystkie(i));
end
