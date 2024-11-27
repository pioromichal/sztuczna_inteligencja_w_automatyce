clear all;
addpath('DMC');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;
h2_lin = h2pp;

% Parametry symulacji
tk=2500; Tp=10; kk=round(tk/Tp);

punkty_rozmycia = h2pp*[0.5; 0.75; 1; 1.25; 1.5];
% DMC parametry
N=70; Nu=30; D=200;
lambdy = [1, 1, 1, 1, 1];

% DMC obliczenia offline
[ke_r, ku_r] = DMC_rozmyty_offline(punkty_rozmycia, lambdy, Tp);

for dh2zad_sign=[-1 , 1]
for dh2zad_per=[10, 20, 30, 40, 50]
    % % Wartość zadana
    h2zad_val=h2pp*(1+dh2zad_sign*dh2zad_per/100);

    [t, h_vals, F1in_vals]=DMC_rozmyty_online(kk, Tp, ke_r, ku_r, D, ...
        h2zad_val, FDpp, punkty_rozmycia);

    % Wyświetlenie wyników w jednym oknie
    figure;
    k_vals=0:Tp:(kk-1)*Tp;
    % Pierwszy wykres - Sygnał wyjściowy
    subplot(2, 1, 1);
    % plot(t, h_vals(:,2));
    plot(k_vals, h_vals(:,2));
    hold on;
    plot(k_vals, h2zad_val * ones(1,kk), '--');
    if dh2zad_sign < 0
        legend('h2(t)', 'h_{zad}', 'Location','northeast');
    else
        legend('h2(t)', 'h_{zad}', 'Location','southeast');
    end
    xlabel('Czas (t)');
    ylabel('Wysokość h_2');
    title('Sygnał wyjściowy DMC jednowymiarowego');
    grid on; grid minor;

    % Drugi wykres - Sygnał sterujący
    subplot(2, 1, 2);
    stairs(k_vals, F1in_vals);
    if dh2zad_sign < 0
        legend('F1in(t)', 'Location','northeast');
    else
        legend('F1in(t)', 'Location','southeast');
    end
    xlabel('Czas (t)');
    ylabel('Sygnał sterujący');
    title('Sygnał sterujący DMC jednowymiarowego');
    grid on; grid minor;

    file_name = sprintf('wykresy/Zad2/symulacja_DMC_rozmyty_j_zmiana_h2_zad_o_%+d_procent.pdf', dh2zad_sign * dh2zad_per);

    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
    % close all;
end
end