clear all;
addpath("funkcje_przynaleznosci");

% Punkt pracy
FDpp = 14; F1pp = 73; h2pp = 15.6384; h1pp = 18.9225;

% Parametry symulacji
tk = 10000;
tspan = [0 tk];
h0 = [h1pp h2pp];

% Definicja modeli lokalnych
h2_lin_rozm_2 = h2pp * [1; 1.5];
h2_lin_rozm_3 = h2pp * [0.5; 1; 1.5];
h2_lin_rozm_4 = h2pp * [0.75; 1; 1.25; 1.5];
h2_lin_rozm_5 = h2pp * [0.5; 0.75; 1; 1.25; 1.5];

% Inicjalizacja wektorów wyników
hs = [];
hsl = [];
hsr2 = [];
hsr3 = [];
hsr4 = [];
hsr5 = [];

F1in_vals = 40:0.25:110;

% Symulacja statyczna
for F1in = F1in_vals
    % Parametry skoku
    FD = FDpp;

    % Symulacja modeli obiektu dla skoku sterowania
    [~, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [~, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, h2pp);
    [~, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_2, 0);
    [~, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_3, 0);
    [~, h_rozm4] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_4, 0);
    [~, h_rozm5] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, 0);

    % Zapis końcowych wartości h_2
    hs = [hs, h_nlin(end, 2)];
    hsl = [hsl, h_lin(end, 2)];
    hsr2 = [hsr2, h_rozm2(end, 2)];
    hsr3 = [hsr3, h_rozm3(end, 2)];
    hsr4 = [hsr4, h_rozm4(end, 2)];
    hsr5 = [hsr5, h_rozm5(end, 2)];
end

% Obliczanie błędów kwadratowych
error_lin = sum((hs - hsl).^2);
error_rozm2 = sum((hs - hsr2).^2);
error_rozm3 = sum((hs - hsr3).^2);
error_rozm4 = sum((hs - hsr4).^2);
error_rozm5 = sum((hs - hsr5).^2);

% Tworzenie tabeli wyników błędów
error_table = {
    'Model', 'Błąd kwadratowy';
    'Liniowy', error_lin;
    'Rozmyty 2', error_rozm2;
    'Rozmyty 3', error_rozm3;
    'Rozmyty 4', error_rozm4;
    'Rozmyty 5', error_rozm5
};

% Zapis błędów do pliku CSV
writecell(error_table, 'wykresy/Zad2/errors_por_modeli_rozm_F1in_stat.csv');

% Wyświetlenie wyników dla różnych ilości modeli lokalnych
for models_num = 2:5
    % Tworzenie nowej figury dla każdego wykresu
    figure;
    plot(F1in_vals, hs, 'k', 'DisplayName', 'Model nieliniowy');
    hold on;
    plot(F1in_vals, hsl, '-.', 'DisplayName', 'Model liniowy');

    % Przypisanie odpowiednich wartości w zależności od liczby modeli
    switch models_num
        case 2
            plot(F1in_vals, hsr2, '--', 'DisplayName', 'Model rozmyty 2');
        case 3
            plot(F1in_vals, hsr3, '--', 'DisplayName', 'Model rozmyty 3');
        case 4
            plot(F1in_vals, hsr4, '--', 'DisplayName', 'Model rozmyty 4');
        case 5
            plot(F1in_vals, hsr5, '--', 'DisplayName', 'Model rozmyty 5');
    end

    % Ustawienie tytułów, etykiet i siatki
    xlabel('F_{1in}');
    ylabel('Wysokość h_2');
    legend('Model nieliniowy', 'Model zlinearyzowany', 'Model rozmyty', 'Location','northwest');
    title(['Model rozmyty ', num2str(models_num), ' modelami lokalnymi']);
    legend;
    grid on; grid minor;

    % Generowanie nazwy pliku
    file_name = sprintf('wykresy/Zad2/statyka_rozmyta_%d_modeli.pdf', models_num);

    % Eksport wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end
