clear all;
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');
% Punkt pracy
FDpp = 14; 
F1pp = 73; 
h2pp = 15.6384; 
h1pp = 18.9225;

% Parametry symulacji
tk = 700;
tspan = [0 tk];
h0 = [h1pp h2pp];

% Tworzenie wykresów dla skoków w górę i w dół
figure_gora = figure;
hold on;
grid on; grid minor;
xlabel('Czas (t)');
ylabel('Wysokość h_2');
title('Symulacja modelu nieliniowego dla skoków zakłócenia w górę');

figure_dol = figure;
hold on;
grid on; grid minor;
xlabel('Czas (t)');
ylabel('Wysokość h_2');
title('Symulacja modelu nieliniowego dla skoków zakłócenia w dół');

for dz_sign = [-1, 1]
    for dz_per = [10, 20, 30, 40, 100]
        % Parametry skoku
        FD = FDpp * (1 + dz_sign * dz_per / 100);
        F1in = F1pp;

        % Symulacja modeli obiektu dla skoku sterowania
        [t, h] = skok_mod_nlin(tspan, h0, tk, F1in, FD);

        % Dodawanie danych na odpowiedni wykres
        if dz_sign > 0
            figure(figure_gora);
            plot(t, h(:, 2), 'DisplayName', sprintf('%+d%%', dz_per));
        else
            figure(figure_dol);
            plot(t, h(:, 2), 'DisplayName', sprintf('%+d%%', dz_sign * dz_per));
        end
    end
end

% Dodanie legend do wykresów
figure(figure_gora);
legend('show', 'Location', 'northwest');

figure(figure_dol);
legend('show', 'Location', 'northeast');


% Zapis wykresów do plików PDF
% Dla skoków w górę
file_name_gora = sprintf('wykresy/Zad1/symulacja_skoku_FD_w_gore.pdf');
exportgraphics(figure_gora, file_name_gora, 'ContentType', 'vector');
close(figure_gora);

% Dla skoków w dół
file_name_dol = sprintf('wykresy/Zad1/symulacja_skoku_FD_w_dol.pdf');
exportgraphics(figure_dol, file_name_dol, 'ContentType', 'vector');
close(figure_dol);