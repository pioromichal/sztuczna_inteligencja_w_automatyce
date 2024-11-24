clear all;
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp = 14; 
F1pp = 73; 
h2pp = 15.6384; 
h1pp = 18.9225;

% Parametry symulacji
tk = 2000;
h0 = [h1pp h2pp];
h2_lin = h2pp;
h2_lin_rozm_2 = h2pp * [1; 1.5];
h2_lin_rozm_3 = h2pp * [0.5; 1; 1.5];
h2_lin_rozm_4 = h2pp * [0.75; 1; 1.25; 1.5];
h2_lin_rozm_5 = h2pp * [0.5; 0.75; 1; 1.25; 1.5];

h_switch = 0;

% Przygotowanie macierzy na błędy
errors = [];

for du_sign = [-1, 1]
    for du_per = [10, 20, 30, 40, 50]
        % Parametry skoku
        FD = FDpp;
        F1in = F1pp * (1 + du_sign * du_per / 100);

        if du_sign == 1
            tk = 5000;
        else
            tk = 1000;
        end
        tspan = [0 tk];

        % Symulacja modeli obiektu dla skoku sterowania
        [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
        [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, h2_lin);
        [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_2, h_switch);
        [t_rozm3, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_3, h_switch);
        [t_rozm4, h_rozm4] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_4, h_switch);
        [t_rozm5, h_rozm5] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h_switch);

        % Obliczanie błędów kwadratowych (tylko na podstawie h2)
        err_lin = sum((h_nlin(:, 2) - interp1(t_lin, h_lin(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm2 = sum((h_nlin(:, 2) - interp1(t_rozm2, h_rozm2(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm3 = sum((h_nlin(:, 2) - interp1(t_rozm3, h_rozm3(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm4 = sum((h_nlin(:, 2) - interp1(t_rozm4, h_rozm4(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm5 = sum((h_nlin(:, 2) - interp1(t_rozm5, h_rozm5(:, 2), t_nlin)).^2, 'omitnan');

        % Dodanie błędów do tabeli
        errors = [errors; du_sign * du_per, err_lin, err_rozm2, err_rozm3, err_rozm4, err_rozm5];

        % Wyświetlenie wyników
        figure;
        plot(t_lin, h_lin(:, 2), '-', t_nlin, h_nlin(:, 2), '-');
        hold on;
        plot(t_rozm2, h_rozm2(:, 2), '-.');    
        plot(t_rozm3, h_rozm3(:, 2), '--');    
        plot(t_rozm4, h_rozm4(:, 2), ':');    
        plot(t_rozm5, h_rozm5(:, 2), '--');    

        legend('Model zlinearyzowany', 'Model nieliniowy', ...
            'Model rozmyty 2', 'Model rozmyty 3', ...
            'Model rozmyty 4', 'Model rozmyty 5');
        if du_sign < 0
            legend('Location', 'northeast');
        else
            legend('Location', 'southeast');
        end
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title(['Symulacja modelu nieliniowego po skoku sterowania o ', num2str(du_sign * du_per), '%']);
        grid on; grid minor;

        % Generowanie nazwy pliku
        file_name = sprintf('wykresy/Zad2/symulacja_skoku_F1in_%+d_procent.pdf', du_sign * du_per);

        % Export wykresu do pliku .pdf
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
        close;
    end
end

% Zapisanie błędów do pliku CSV
headers = {'du_per', 'Error_Lin', 'Error_Rozm2', 'Error_Rozm3', 'Error_Rozm4', 'Error_Rozm5'};
file_name_csv = 'wykresy/Zad2/errors_por_modeli_rozm_F1in.csv';
writecell([headers; num2cell(errors)], file_name_csv);
disp(['Błędy zapisano w pliku: ', file_name_csv]);
