clear all;
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=2000;
tspan=[0 tk];
h0=[h1pp h2pp];
h2_lin = h2pp;
h2_lin_rozm=[10; h2pp; 20];
h2_lin_rozm_2=h2pp*[0.5; 1.5];
h2_lin_rozm_3=h2pp*[0.5;1;1.5];
h2_lin_rozm_4=h2pp*[0.5;0.83;1.16;1.5];
h2_lin_rozm_5=h2pp*[0.5;0.75;1;1.25;1.5];

for du_sign=[-1 , 1]
for du_per=[10, 20, 50]
    % Parametry skoku
    FD=FDpp;
    F1in=F1pp*(1+du_sign*du_per/100);

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, h2_lin);
    [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_4, 5);

    
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
    % close;

end
end



