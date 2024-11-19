clear all;
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
% Punkt pracy
FDpp = 14; 
F1pp = 73; 
h2pp = 15.6384; 
h1pp = 18.9225;

% Parametry symulacji
h0 = [h1pp h2pp];

% Tworzenie wykresów dla skoków w górę i w dół
figure_gora = figure;
hold on;
grid on; grid minor;
xlabel('Czas (t)');
ylabel('Wysokość h_2');
title('Symulacja modelu nieliniowego dla skoków sterowania w górę');

figure_dol = figure;
hold on;
grid on; grid minor;
xlabel('Czas (t)');
ylabel('Wysokość h_2');
title('Symulacja modelu nieliniowego dla skoków sterowania w dół');

for du_sign = [-1, 1]
    if du_sign == 1
        tk = 5000;
    else
        tk = 1000;
    end
        tspan = [0 tk];
    for dz_per = [10, 20, 30, 40, 50]
        % Parametry skoku
        F1in = F1pp * (1 + du_sign * dz_per / 100);
        FD = FDpp;

        % Symulacja modeli obiektu dla skoku sterowania
        [t, h] = skok_mod_nlin(tspan, h0, tk, F1in, FD);

        % Dodawanie danych na odpowiedni wykres
        if du_sign > 0
            figure(figure_gora);
            plot(t, h(:, 2), 'DisplayName', sprintf('%+d%%', dz_per));
        else
            figure(figure_dol);
            plot(t, h(:, 2), 'DisplayName', sprintf('%+d%%', du_sign * dz_per));
        end
    end
end

% Dodanie legend do wykresów
figure(figure_gora);
legend('show', 'Location', 'northwest');

figure(figure_dol);
legend('show', 'Location', 'southwest');

% Zapis wykresów do plików PDF
% Dla skoków w górę
file_name_gora = sprintf('wykresy/Zad1/symulacja_skoku_F1in_w_gore.pdf');
exportgraphics(figure_gora, file_name_gora, 'ContentType', 'vector');
close(figure_gora);

% Dla skoków w dół
file_name_dol = sprintf('wykresy/Zad1/symulacja_skoku_F1in_w_dol.pdf');
exportgraphics(figure_dol, file_name_dol, 'ContentType', 'vector');
close(figure_dol);
