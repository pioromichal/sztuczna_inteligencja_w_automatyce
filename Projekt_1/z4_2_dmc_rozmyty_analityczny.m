clear all; close all;
addpath('DMC');

% Punkt pracy
FDpp = 14; F1pp = 73; h2pp = 15.6384; h1pp = 18.9225; dF1in = 10;
h2_lin = h2pp;

% Parametry symulacji
tk = 2500; Tp = 10; kk = round(tk / Tp);

% Parametry DMC rozmytego
punkty_rozmycia = h2pp * [0.5; 0.75; 1; 1.25; 1.5];
D = 500; Dz = 200;
% N_rozmyte = [40, 60, 70, 150, 250];
% Nu_rozmyte = [20, 30, 30, 100, 150];
N_rozmyte = [70, 70, 70, 70, 70];
Nu_rozmyte = [30, 30, 30, 30, 30];
lambda_rozmyte = [15, 15, 15, 15, 15]; % Regulator 1

% Obliczenia offline DMC rozmytego
[ke_r, ku_r,kz_r] = z4_DMC_rozmyty_offline_zakl(punkty_rozmycia, N_rozmyte, Nu_rozmyte, lambda_rozmyte, D, Dz, Tp);





% Symulacja dla zmiany wartości zakłócenia FD
for FD_sign = [-1, 1]
    for FD_per = [10, 50]
        % Zakłócenie FD
        FD = FDpp * (1 + FD_sign * FD_per / 100);

        % Symulacja rozmytego DMC (Regulator 1)
        [t1, h_vals1, F1in_vals1] = DMC_rozmyty_online(kk, Tp, ke_r, ku_r, D, h2pp, FD, punkty_rozmycia, false);

        % Symulacja rozmytego DMC (Regulator 2)
        [t2, h_vals2, F1in_vals2] = z4_DMC_rozmyty_online_zakl(kk, Tp, ke_r, ku_r, kz_r,D, Dz, h2pp, FD, punkty_rozmycia);

        % Wyświetlenie wyników w jednym oknie
        figure;
        k_vals = 0:Tp:(kk-1)*Tp;

        % Pierwszy wykres - Sygnał wyjściowy
        subplot(2, 1, 1);
        plot(k_vals, h_vals1(:, 2), '-'); % Rozmyte DMC (Regulator 1)
        hold on;
        plot(k_vals, h_vals2(:, 2), '--'); % Rozmyte DMC (Regulator 2)
        plot(k_vals, h2pp * ones(1, kk), ':'); % Wartość zadana
        legend('h2 - bez pomiaru z', 'h2 - z pomiarem z','h_{zad}', 'Location', 'best');
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title('DMC rozmyty analityczny - uwzglednienie zakłóceń');
        grid on;

        % Drugi wykres - Sygnał sterujący
        subplot(2, 1, 2);
        stairs(k_vals, F1in_vals1, '-'); % Rozmyte DMC (Regulator 1)
        hold on;
        stairs(k_vals, F1in_vals2(2:251), '-'); % Rozmyte DMC (Regulator 2)
        ylabel('Sygnał sterujący');
        yyaxis right;
        FD_vals(1:8) = FDpp;
        FD_vals(9:250) = FD;
        stairs(k_vals,FD_vals)
        legend('F1in - bez pomiaru z', 'F1in - z pomiarem z', 'Location', 'best');
        xlabel('Czas (t)');
        ylabel('Sygnał zakłócający');
        title('DMC rozmyty analityczny - uwzglednienie zakłóceń');
        grid on;

        % Zapis wykresu do pliku PDF
        file_name = sprintf('wykresy/Zad4/DMC_rozm_Pomzakl_zmiana_FD_o_%+d_procent.pdf', FD_sign * FD_per);
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
    end
end
