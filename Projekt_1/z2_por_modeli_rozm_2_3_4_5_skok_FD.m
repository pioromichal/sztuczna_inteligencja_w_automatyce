clear all;
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=2000;
tspan=[0 tk];
h0=[h1pp h2pp];
h2_lin = h2pp;
h2_lin_rozm_2=h2pp*[1; 1.5];
h2_lin_rozm_3=h2pp*[0.5;1;1.5];
h2_lin_rozm_4=h2pp*[0.75;1;1.25;1.5];
h2_lin_rozm_5=h2pp*[0.5;0.75;1;1.25;1.5];

h_switch=0;

% Przygotowanie tablicy do zapisu błędów
error_table = [];

for dz_sign = [-1, 1]
    for dz_per = [10, 20, 30, 40, 50]
        % Parametry skoku
        FD = FDpp * (1 + dz_sign * dz_per / 100);
        F1in = F1pp;

        % Symulacja modeli obiektu dla skoku zakłócenia
        [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
        [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, h2_lin);
        [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_2, h_switch);
        [t_rozm3, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_3, h_switch);
        [t_rozm4, h_rozm4] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_4, h_switch);
        [t_rozm5, h_rozm5] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h_switch);

        % Interpolacja do czasu modelu nieliniowego (jeśli potrzeba)
        h_lin_interp = interp1(t_lin, h_lin(:, 2), t_nlin, 'linear', 'extrap');
        h_rozm2_interp = interp1(t_rozm2, h_rozm2(:, 2), t_nlin, 'linear', 'extrap');
        h_rozm3_interp = interp1(t_rozm3, h_rozm3(:, 2), t_nlin, 'linear', 'extrap');
        h_rozm4_interp = interp1(t_rozm4, h_rozm4(:, 2), t_nlin, 'linear', 'extrap');
        h_rozm5_interp = interp1(t_rozm5, h_rozm5(:, 2), t_nlin, 'linear', 'extrap');

        % Obliczanie błędów kwadratowych
        err_lin = sum((h_nlin(:, 2) - h_lin_interp).^2);
        err_rozm2 = sum((h_nlin(:, 2) - h_rozm2_interp).^2);
        err_rozm3 = sum((h_nlin(:, 2) - h_rozm3_interp).^2);
        err_rozm4 = sum((h_nlin(:, 2) - h_rozm4_interp).^2);
        err_rozm5 = sum((h_nlin(:, 2) - h_rozm5_interp).^2);

        % Dodanie wyników do tabeli
        error_table = [error_table; dz_sign * dz_per, err_lin, err_rozm2, err_rozm3, err_rozm4, err_rozm5];

        % Wyświetlenie wyników
        figure;
        plot(t_lin, h_lin(:, 2), '-', t_nlin, h_nlin(:, 2), '-');
        hold on;
        plot(t_rozm2, h_rozm2(:, 2), '-.');
        plot(t_rozm3, h_rozm3(:, 2), '--');
        plot(t_rozm4, h_rozm4(:, 2), ':');
        plot(t_rozm5, h_rozm5(:, 2), '--');
        legend('Model nieliniowy', 'Model zlinearyzowany', ...
            'Model rozmyty 2', 'Model rozmyty 3', ...
            'Model rozmyty 4', 'Model rozmyty 5');
        if dz_sign < 0
            legend('Location', 'northeast');
        else
            legend('Location', 'southeast');
        end
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title(['Symulacja modelu nieliniowego po skoku zakłócenia o ', num2str(dz_sign * dz_per), '%']);
        grid on; grid minor;

        % Generowanie nazwy pliku
        file_name = sprintf('wykresy/Zad2/symulacja_skoku_FD_%+d_procent.pdf', dz_sign * dz_per);

        % Export wykresu do pliku .pdf
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
        close;
    end
end

% Zapisanie błędów do pliku CSV
error_headers = {'Zakłócenie [%]', 'Błąd liniowy', 'Błąd rozmyty 2', 'Błąd rozmyty 3', 'Błąd rozmyty 4', 'Błąd rozmyty 5'};
error_table_with_headers = [error_headers; num2cell(error_table)];
writecell(error_table_with_headers, 'wykresy/Zad2/errors_por_modeli_rozm_FD.csv');
