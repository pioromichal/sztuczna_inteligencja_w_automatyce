clear all; close all;
addpath('DMC');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;
h2_lin = h2pp;
dFD = 20;

% Parametry symulacji
tk=2500; Tp=10; kk=round(tk/Tp);

% DMC parametry
N=70; Nu=30; D=500; lambda=15; Dz = 200;

% DMC obliczenia offline
ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
yz = odp_jedn_zakl_fun(D, Tp, dFD,h2_lin);
[ke, ku, kz] = z4_DMC_offline_zakl(ys,yz,N,Nu,lambda,D, Dz);



h2zad_val=h2pp;


for FD_sign=[-1 , 1]
for FD_per=[10, 20, 30, 40, 50]
    FD=FDpp*(1+FD_sign*FD_per/100);
    % % Wartość zadana
    [t, h_vals, F1in_vals]=DMC_online(kk, Tp, ke, ku, D, h2zad_val, FD);
    [t_z, h_vals_z, F1in_vals_z]=z4_DMC_online_zakl(kk, Tp, ke, ku, kz, D, Dz, h2zad_val, FD);

    % Wyświetlenie wyników w jednym oknie
    figure;
    k_vals=0:Tp:(kk-1)*Tp;
    % Pierwszy wykres - Sygnał wyjściowy
    subplot(2, 1, 1);
    % plot(t, h_vals(:,2));
    hold on;
    plot(k_vals, h_vals(:,2));
    plot(k_vals, h_vals_z(:,2));
    
    plot(k_vals, h2zad_val * ones(1,kk), '--');
    if FD_sign < 0
        legend('h2(t) - bez pomiaru z', 'h2(t) - z pomiarem z','h_{zad}', 'Location','best');
    else
        legend('h2(t) - bez pomiaru z', 'h2(t) - z pomiarem z', 'h_{zad}', 'Location','best');
    end
    xlabel('Czas (t)');
    ylabel('Wysokość h_2');
    title('DMC konwencjonalny - uwzgledniennie zakłóceń');
    grid on; grid minor;

    % Drugi wykres - Sygnał sterujący
    subplot(2, 1, 2);
    % yyaxis left;
    hold on;
    stairs(k_vals, F1in_vals);
    stairs(k_vals, F1in_vals_z(2:251));
    ylabel('Sygnał sterujący');
    yyaxis right;
    FD_vals(1:8)=FDpp;
    FD_vals(9:kk) = FD;
    stairs(k_vals, FD_vals);
    if FD_sign < 0
        legend('F1in(t) - bez pomiaru z', 'F1in(t) - z pomiarem z', 'Location','best');
    else
        legend('F1in(t) - bez pomiaru z', 'F1in(t) - z pomiarem z', 'Location','best');
    end
    xlabel('Czas (t)');
    ylabel('Sygnał zakłócenia');
    title('DMC konwencjonalny - uwzgledniennie zakłóceń');
    grid on; grid minor;

    file_name = sprintf('wykresy/Zad4/DMC_zakl_zmiana_FD_o_%+d_procent.pdf', FD_sign * FD_per);

    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
    % close all;
end
end