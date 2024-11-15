clear all;
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=2000;
tspan=[0 tk];
h0=[h1pp h2pp];
h_lin=[h1pp h2pp; 46.9225 38.7789];

for du_sign=[-1 , 1]
for du_per=[10, 20, 50]
    % Parametry skoku
    FD=FDpp;
    F1in=F1pp*(1+du_sign*du_per/100);

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, h0);
    [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h_lin, 0);

    
    % Wyświetlenie wyników
    figure;
    plot(t_nlin, h_nlin(:,2), '-', t_lin, h_lin(:,2), '-.');
    hold on;
    plot(t_rozm2, h_rozm2(:,2), '--');    
    legend('Model nieliniowy', 'Model zlinearyzowany', 'Model rozmyty 2');
    if du_sign < 0
        legend('Location','northeast');
    else
        legend('Location','southeast');
    end
    xlabel('Czas (t)');
    ylabel('Wysokość h_2');
    title(['Symulacja modelu nieliniowego po skoku sterowania o ', num2str(du_sign*du_per), '%']);
    grid on; grid minor;

    % Generowanie nazwy pliku
    file_name = sprintf('wykresy/Zad2/symulacja_skoku_F1in_%+d_procent.pdf', du_sign * du_per);

    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
    close;

end
end



