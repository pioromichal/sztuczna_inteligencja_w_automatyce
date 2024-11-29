clear all;
addpath('DMC');
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp = 14; F1pp = 73; h2pp = 15.6384; h1pp = 18.9225; dF1in = 10;
h2_lin = h2pp;

% Parametry symulacji
tk = 2500; Tp = 10; kk = round(tk / Tp);

% Parametry DMC klasycznego
Nj = 70; Nuj = 30; Dj = 160; lambdaj = 15;

% Obliczenia offline DMC klasycznego
ys = odp_jedn_fun(Dj, Tp, dF1in, h2_lin);
[ke, ku] = DMC_offline(ys, Nj, Nuj, lambdaj, Dj);

% Parametry DMC rozmytego
punkty_rozmycia = h2pp * [0.5; 0.75; 1; 1.25; 1.5];
D1=200;
D2=500;
N_rozmyte = [70, 70, 70, 70, 70];
Nu_rozmyte = [30, 30, 30, 30, 30];
lambda_rozmyte = [15, 15, 15, 15, 15]; % Regulator 1

% Obliczenia offline DMC rozmytego
[ke_r1, ku_r1] = DMC_rozmyty_offline(punkty_rozmycia, N_rozmyte, Nu_rozmyte, lambda_rozmyte, D1, Tp);
[ke_r2, ku_r2] = DMC_rozmyty_offline(punkty_rozmycia, N_rozmyte, Nu_rozmyte, lambda_rozmyte, D2, Tp);

% Symulacja dla zmiany wartości zakłócenia FD
for FD_sign = [-1, 1]
    for FD_per = [10, 20, 30, 40, 50]
        % Zakłócenie FD
        FD = FDpp * (1 + FD_sign * FD_per / 100);

        % Symulacja rozmytego DMC (Regulator 1)
        [t1, h_vals1, F1in_vals1] = DMC_rozmyty_online(kk, Tp, ke_r1, ku_r1, D1, h2pp, FD, punkty_rozmycia, false);

        % Symulacja rozmytego DMC (Regulator 2)
        [t2, h_vals2, F1in_vals2] = DMC_rozmyty_online(kk, Tp, ke_r2, ku_r2, D2, h2pp, FD, punkty_rozmycia, true);

        % Symulacja klasycznego DMC
        [tj, h_valsj, F1in_valsj] = DMC_online(kk, Tp, ke, ku, Dj, h2pp, FD);

        % Wyświetlenie wyników w jednym oknie
        figure;
        k_vals = 0:Tp:(kk-1)*Tp;

        % Pierwszy wykres - Sygnał wyjściowy
        subplot(2, 1, 1);
        plot(k_vals, h_vals1(:, 2), '-'); % Rozmyte DMC (Regulator 1)
        hold on;
        plot(k_vals, h_vals2(:, 2), '--'); % Rozmyte DMC (Regulator 2)
        plot(k_vals, h_valsj(:, 2), '-.'); % Klasyczne DMC
        plot(k_vals, h2pp * ones(1, kk), '--'); % Wartość zadana
        if FD_sign < 0
           legend('h2: Rozmyte DMC (1)', 'h2: Rozmyte DMC (2)', 'h2: Klasyczne DMC', 'h_{zad}', 'Location', 'southeast');
        else
           legend('h2: Rozmyte DMC (1)', 'h2: Rozmyte DMC (2)', 'h2: Klasyczne DMC', 'h_{zad}', 'Location', 'northeast');
        end
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title('Sygnał wyjściowy DMC');
        grid on;

        % Drugi wykres - Sygnał sterujący
        subplot(2, 1, 2);
        stairs(k_vals, F1in_vals1, '-'); % Rozmyte DMC (Regulator 1)
        hold on;
        stairs(k_vals, F1in_vals2, '--'); % Rozmyte DMC (Regulator 2)
        stairs(k_vals, F1in_valsj, '-.'); % Klasyczne DMC
        if FD_sign < 0
            legend('F1in: Rozmyte DMC (1)', 'F1in: Rozmyte DMC (2)', 'F1in: Klasyczne DMC', 'Location', 'southeast');
        else
            legend('F1in: Rozmyte DMC (1)', 'F1in: Rozmyte DMC (2)', 'F1in: Klasyczne DMC', 'Location', 'northeast');
        end
        xlabel('Czas (t)');
        ylabel('Sygnał sterujący');
        title('Sygnał sterujący DMC');
        grid on;

        % Zapis wykresu do pliku PDF
        file_name = sprintf('wykresy/Zad2/symulacja_DMC_r_zmiana_FD_o_%+d_procent.pdf', FD_sign * FD_per);
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
    end
end
