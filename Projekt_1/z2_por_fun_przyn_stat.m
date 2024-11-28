clear all;
addpath("funkcje_przynaleznosci");

% Punkt pracy
FDpp = 14; F1pp = 73; h2pp = 15.6384; h1pp = 18.9225;

% Parametry symulacji
tk = 10000;
tspan = [0 tk];
h0 = [h1pp h2pp];

% Definicja modeli lokalnych
h2_lin_rozm_5 = h2pp * [0.5; 0.75; 1; 1.25; 1.5];

% Inicjalizacja wektorów wyników
hs = [];
hsr1 = [];
hsr2 = [];
hsr3 = [];
hsr4 = [];
hsr5 = [];
hsr6 = [];

F1in_vals = 30:0.25:110;

% Symulacja statyczna
for F1in = F1in_vals
    % Parametry skoku
    FD = FDpp;

    % Symulacja modeli obiektu dla skoku sterowania
    [~, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [~, h_rozm1] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, 0);
    [~, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.05);
    [~, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.1);
    [~, h_rozm4] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.25);
    [~, h_rozm5] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.15,true);
    [~, h_rozm6] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.2,true);

    % Zapis końcowych wartości h_2
    hs = [hs, h_nlin(end, 2)];
    hsr1 = [hsr1, h_rozm1(end, 2)];
    hsr2 = [hsr2, h_rozm2(end, 2)];
    hsr3 = [hsr3, h_rozm3(end, 2)];
    hsr4 = [hsr4, h_rozm4(end, 2)];
    hsr5 = [hsr5, h_rozm5(end, 2)];
    hsr6 = [hsr6, h_rozm6(end, 2)];

end

% Obliczanie błędów kwadratowych
error_rozm1 = sum((hs - hsr1).^2);
error_rozm2 = sum((hs - hsr2).^2);
error_rozm3 = sum((hs - hsr3).^2);
error_rozm4 = sum((hs - hsr4).^2);
error_rozm5 = sum((hs - hsr5).^2);
error_rozm6 = sum((hs - hsr6).^2);

% Tworzenie tabeli wyników błędów
error_table = {
    'Model', 'Błąd kwadratowy';
    'Funkcja 1', error_rozm1;
    'Funkcja 2', error_rozm2;
    'Funkcja 3', error_rozm3;
    'Funkcja 4', error_rozm4;
    'Funkcja 5', error_rozm5;
    'Funkcja 6', error_rozm6

};

% Zapis błędów do pliku CSV
writecell(error_table, 'wykresy/Zad2/errors_por_fun_przyn_F1in_stat.csv');

% Inicjalizacja wektorów wyników
hs = [];
hsr1 = [];
hsr2 = [];
hsr3 = [];
hsr4 = [];
hsr5 = [];
hsr6 = [];

for FD = FD_vals
    % Parametry skoku
    F1in = F1pp;

    % Symulacja modeli obiektu dla skoku sterowania
    [~, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [~, h_rozm1] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, 0);
    [~, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.05);
    [~, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.1);
    [~, h_rozm4] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.25);
    [~, h_rozm5] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.15, true);
    [~, h_rozm6] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.2, true);

    % Zapis końcowych wartości h_2
    hs = [hs, h_nlin(end, 2)];
    hsr1 = [hsr1, h_rozm1(end, 2)];
    hsr2 = [hsr2, h_rozm2(end, 2)];
    hsr3 = [hsr3, h_rozm3(end, 2)];
    hsr4 = [hsr4, h_rozm4(end, 2)];
    hsr5 = [hsr5, h_rozm5(end, 2)];
    hsr6 = [hsr6, h_rozm6(end, 2)];
end

% Obliczanie błędów kwadratowych
error_rozm1 = sum((hs - hsr1).^2);
error_rozm2 = sum((hs - hsr2).^2);
error_rozm3 = sum((hs - hsr3).^2);
error_rozm4 = sum((hs - hsr4).^2);
error_rozm5 = sum((hs - hsr5).^2);
error_rozm6 = sum((hs - hsr6).^2);

% Tworzenie tabeli wyników błędów
error_table = {
    'Model', 'Błąd kwadratowy';
    'Funkcja 1', error_rozm1;
    'Funkcja 2', error_rozm2;
    'Funkcja 3', error_rozm3;
    'Funkcja 4', error_rozm4;
    'Funkcja 5', error_rozm5;
    'Funkcja 6', error_rozm6
};

% Zapis błędów do pliku CSV
file_name_csv = 'wykresy/Zad2/errors_por_fun_przyn_FD_stat.csv';
writecell(error_table, file_name_csv);


% Wyświetlenie wyników dla różnych ilości modeli lokalnych
% for models_num = 1:6
%     % Tworzenie nowej figury dla każdego wykresu
%     figure;
%     plot(F1in_vals, hs, 'k', 'DisplayName', 'Model nieliniowy');
%     hold on;
% 
%     % Przypisanie odpowiednich wartości w zależności od liczby modeli
%     switch models_num
%         case 1
%             plot(F1in_vals, hsr1, '--', 'DisplayName', 'Model rozmyty 1');
%         case 2
%             plot(F1in_vals, hsr2, '--', 'DisplayName', 'Model rozmyty 2');
%         case 3
%             plot(F1in_vals, hsr3, '--', 'DisplayName', 'Model rozmyty 3');
%         case 4
%             plot(F1in_vals, hsr4, '--', 'DisplayName', 'Model rozmyty 4');
%         case 5
%             plot(F1in_vals, hsr5, '--', 'DisplayName', 'Model rozmyty 5');
%         case 6
%             plot(F1in_vals, hsr6, '--', 'DisplayName', 'Model rozmyty 6');
% 
%     end
% 
%     % Ustawienie tytułów, etykiet i siatki
%     xlabel('F_{1in}');
%     ylabel('Wysokość h_2');
%     legend('Model nieliniowy', 'Model zlinearyzowany', 'Model rozmyty', 'Location','northwest');
%     title(['Model rozmyty ', num2str(models_num), ' modelami lokalnymi']);
%     legend;
%     grid on; grid minor;
% 
%     % Generowanie nazwy pliku
%     file_name = sprintf('wykresy/Zad2/statyka_rozmyta_%d_modeli_fun_przyn.pdf', models_num);
% 
%     % Eksport wykresu do pliku .pdf
%     exportgraphics(gcf, file_name, 'ContentType', 'vector');
% end
