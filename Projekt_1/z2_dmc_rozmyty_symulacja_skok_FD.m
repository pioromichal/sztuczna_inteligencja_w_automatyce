clear all;
addpath('DMC');

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
D = 500;  % Parametr opóźnienia
N_rozmyte = [40, 60, 70, 150, 250];  % Różne długości okna dla rozmytego DMC
Nu_rozmyte = [20, 30, 30, 100, 150];  % Różne długości okna sterującego dla rozmytego DMC
lambda_rozmyte = [15, 15, 15, 25, 25];  % Różne wartości współczynnika dla rozmytego DMC

% Obliczenia offline DMC rozmytego
[ke_r, ku_r] = DMC_rozmyty_offline(punkty_rozmycia, N_rozmyte, Nu_rozmyte, lambda_rozmyte, D, Tp);

% Symulacja dla zmiany wartości zadanej \( F_D \)
for FD_sign = [-1, 1]
    for FD_per = [10, 20, 30, 40, 50]
        % Wartość zadana \( F_D \)
        FD = FDpp * (1 + FD_sign * FD_per / 100);

        % Symulacja DMC rozmytego
        [t, h_vals, F1in_vals] = DMC_rozmyty_online(kk, Tp, ke_r, ku_r, D, h2pp, FD, punkty_rozmycia);

        % Symulacja klasycznego DMC
        [tj, h_valsj, F1in_valsj] = DMC_online(kk, Tp, ke, ku, Dj, h2pp, FD);

        % Wyświetlenie wyników w jednym oknie
        figure;
        k_vals = 0:Tp:(kk-1)*Tp;

        % Pierwszy wykres - Sygnał wyjściowy
        subplot(2, 1, 1);
        plot(k_vals, h_vals(:, 2)); % DMC rozmyte
        hold on;
        plot(k_vals, h_valsj(:, 2), '--'); % Klasyczne DMC
        plot(k_vals, h2pp * ones(1, kk), '-.');
        if FD_sign < 0
            legend('h2: DMC rozmyte', 'h2: DMC klasyczne', 'h_{zad}', 'Location', 'northeast');
        else
            legend('h2: DMC rozmyte', 'h2: DMC klasyczne', 'h_{zad}', 'Location', 'southeast');
        end
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title('Sygnał wyjściowy DMC');
        grid on; grid minor;

        % Drugi wykres - Sygnał sterujący
        subplot(2, 1, 2);
        stairs(k_vals, F1in_vals); % DMC rozmyte
        hold on;
        stairs(k_vals, F1in_valsj, '--'); % Klasyczne DMC
        if FD_sign < 0
            legend('F1in: DMC rozmyte', 'F1in(t): DMC klasyczne', 'Location', 'northeast');
        else
            legend('F1in: DMC rozmyte', 'F1in(t): DMC klasyczne', 'Location', 'southeast');
        end
        xlabel('Czas (t)');
        ylabel('Sygnał sterujący');
        title('Sygnał sterujący DMC');
        grid on; grid minor;

        % Zapis wykresu do pliku PDF
        file_name = sprintf('wykresy/Zad2/symulacja_DMC_r_zmiana_FD_o_%+d_procent.pdf', FD_sign * FD_per);
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
    end
end
