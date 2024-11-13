clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=2000;
tspan=[0 tk];
h0=[h1pp h2pp];

for du_sign=[-1 , 1]
for du_per=[10, 20, 50]
    % Parametry skoku
    FD=FDpp;
    F1in=F1pp*(1+du_sign*du_per/100);

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD, F1pp, FDpp);
    [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, F1pp, FDpp, h0);
    
    % Wyświetlenie wyników
    figure;
    plot(t_nlin, h_nlin(:,2), '-', t_lin, h_lin(:,2), ':');
    legend('Model nieliniowy', 'Model zlinearyzowany');
    xlabel('Czas (t)');
    ylabel('Wysokość h_2');
    title(['Symulacja modelu nieliniowego po skoku sterowania o ', num2str(du_sign*du_per), '%']);
    grid on; grid minor;

    % Generowanie nazwy pliku
    file_name = sprintf('wykresy/Zad1/symulacja_skoku_F1in_%+d_procent.pdf', du_sign * du_per);

    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
    close;

end
end



