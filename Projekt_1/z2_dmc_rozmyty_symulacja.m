clear all;
addpath('DMC');
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;
h2_lin = h2pp;

% Parametry symulacji
tk=2500; Tp=10; kk=round(tk/Tp);

% DMC parametry
Nj=70; Nuj=30; Dj=200; lambdaj=15;

% DMC obliczenia offline
ys=odp_jedn_fun(Dj, Tp, dF1in, h2_lin);
[ke, ku] = DMC_offline(ys,Nj,Nuj,lambdaj,Dj);

punkty_rozmycia = h2pp*[0.5; 0.75; 1; 1.25; 1.5];
% DMC parametry
D1=200;
D2=500;

N1 = [70, 70, 70, 70, 70];
Nu1 = [30, 30, 30, 30, 30];
lambda1 = [15, 15, 15, 15, 15];
N2 = [70, 70, 70, 70, 70];
Nu2 = [30, 30, 30, 30, 30];
lambda2 = [15, 15, 15, 15, 15];


% DMC obliczenia offline
[ke_r1, ku_r1] = DMC_rozmyty_offline(punkty_rozmycia,N1,Nu1,lambda1,D1, Tp);
[ke_r2, ku_r2] = DMC_rozmyty_offline(punkty_rozmycia,N2,Nu2,lambda2,D2, Tp);

for dh2zad_sign=[-1, 1]
    for dh2zad_per=[10, 20, 30, 40, 50]
        % Wartość zadana
        h2zad_val=h2pp*(1+dh2zad_sign*dh2zad_per/100);

        % Symulacja DMC rozmytego (1. wersja)
        [t, h_vals, F1in_vals]=DMC_rozmyty_online(kk, Tp, ke_r1, ku_r1, D1, ...
            h2zad_val, FDpp, punkty_rozmycia, false);

        % Symulacja DMC rozmytego (2. wersja - inny parametr rozmyty)
        [t2, h_vals2, F1in_vals2]=DMC_rozmyty_online(kk, Tp, ke_r2, ku_r2, D2, ...
            h2zad_val, FDpp, punkty_rozmycia, true);

        % Symulacja klasycznego DMC
        [tj, h_valsj, F1in_valsj]=DMC_online(kk, Tp, ke, ku, Dj, h2zad_val, FDpp);

        % Wyświetlenie wyników w jednym oknie
        figure;
        k_vals = 0:Tp:(kk-1)*Tp;

        % Pierwszy wykres - Sygnał wyjściowy
        subplot(2, 1, 1);
        plot(k_vals, h_vals(:,2)); % DMC rozmyte (1. wersja)
        hold on;
        plot(k_vals, h_vals2(:,2), '--'); % DMC rozmyte (2. wersja)
        plot(k_vals, h_valsj(:,2), '-.'); % Klasyczne DMC
        plot(k_vals, h2zad_val * ones(1,kk), '--'); % Wartość zadana
        legend('h2: DMC rozmyte (1)', 'h2: DMC rozmyte (2)', 'h2: DMC klasyczne', 'h_{zad}', 'Location', 'best');
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title('Sygnał wyjściowy DMC');
        grid on; grid minor;

        % Drugi wykres - Sygnał sterujący
        subplot(2, 1, 2);
        stairs(k_vals, F1in_vals); % DMC rozmyte (1. wersja)
        hold on;
        stairs(k_vals, F1in_vals2, ':'); % DMC rozmyte (2. wersja)
        stairs(k_vals, F1in_valsj, '--'); % Klasyczne DMC
        legend('F1in: DMC rozmyte (1)', 'F1in: DMC rozmyte (2)', 'F1in: DMC klasyczne', 'Location', 'best');
        xlabel('Czas (t)');
        ylabel('Sygnał sterujący');
        title('Sygnał sterujący DMC');
        grid on; grid minor;

        % Zapis wykresu do pliku PDF
        file_name = sprintf('wykresy/Zad2/symulacja_DMC_r_zmiana_h2_zad_o_%+d_procent.pdf', dh2zad_sign * dh2zad_per);
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
    end
end

