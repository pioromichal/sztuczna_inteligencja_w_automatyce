clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=4000;
tspan=[0 tk];
h0=[h1pp h2pp];
h2_lin = h2pp;

for du_sign=[-1 , 1]
for du_per=[10, 20, 30, 40, 50]
    if du_sign == 1
        tk = 5000;
    else
        tk = 1000;
    end
        tspan = [0 tk];
    % Parametry skoku
    FD=FDpp;
    F1in=F1pp*(1+du_sign*du_per/100);

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, h2_lin);
    
    % Wyświetlenie wyników
    figure('Units', 'centimeters', 'Position', [1, 1, 7, 6]);
    plot(t_nlin, h_nlin(:,2), '-', t_lin, h_lin(:,2), '-.');
    if du_sign < 0
        legend('Nieliniowy', 'Zlinearyzowany', 'Location','northeast');
    else
        legend('Nieliniowy', 'Zlinearyzowany', 'Location','southeast');
    end
    xlabel('Czas (t)');
    ylabel('h_2');
    title(['Skok sterowania o ', num2str(du_sign*du_per), '%']);
    grid on; grid minor;

    % Generowanie nazwy pliku
    file_name = sprintf('wykresy/Zad1/symulacja_skoku_F1in_%+d_procent.pdf', du_sign * du_per);

    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
    close;

end
end



