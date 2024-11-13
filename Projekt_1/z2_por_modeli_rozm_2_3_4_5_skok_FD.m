clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=2000;
tspan=[0 tk];
h0=[h1pp h2pp];
h_lin=[h1pp h2pp; 46.9225 38.7789];

for dz_sign=[-1 , 1]
for dz_per=[10, 20, 50]
    % Parametry skoku
    FD=FDpp*(1+dz_sign*dz_per/100);
    F1in=F1pp;

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD, F1pp, FDpp);
    [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, F1pp, FDpp, h0);
    [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, F1pp, FDpp, h_lin, 0);

    % Wyświetlenie wyników
    figure;
    plot(t_nlin, h_nlin(:,2), '-', t_lin, h_lin(:,2), '-.');
    hold on;
    plot(t_rozm2, h_rozm2(:,2), '--');
    legend('Model nieliniowy', 'Model zlinearyzowany', 'Model rozmyty 2');
    if dz_sign < 0
        legend('Location','northeast');
    else
        legend('Location','southeast');
    end
    xlabel('Czas (t)');
    ylabel('Wysokość h_2');
    title(['Symulacja modelu nieliniowego po skoku zakłócenia o ', num2str(dz_sign*dz_per), '%']);
    grid on; grid minor;

    % Generowanie nazwy pliku
    file_name = sprintf('wykresy/Zad2/symulacja_skoku_FD_%+d_procent.pdf', dz_sign * dz_per);

    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
    close;

end
end
