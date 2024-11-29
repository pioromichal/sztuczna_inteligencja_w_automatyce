clear all;
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp = 14; 
F1pp = 73; 
h2pp = 15.6384; 
h1pp = 18.9225;

% Parametry symulacji
tk = 5000;
h0 = [h1pp h2pp];
h2_lin = h2pp;
h2_lin_rozm_5 = h2pp * [0.5; 0.75; 1; 1.25; 1.5];
h2_vals= linspace(0.4 * h2pp, 1.6 * h2pp, 500);

for h2_switch_num = 1:6
    mi_vals = [];
    for h2 = h2_vals
        % Wybór odpowiednich wartości na podstawie liczby modeli
        switch h2_switch_num
            case 1
                mi_vals = [mi_vals; fun_przyn_trap(h2, h2_lin_rozm_5, 0)];
            case 2
                mi_vals = [mi_vals; fun_przyn_trap(h2, h2_lin_rozm_5, h2pp*0.05)];
            case 3
                mi_vals = [mi_vals; fun_przyn_trap(h2, h2_lin_rozm_5, h2pp*0.15)];
            case 4
                mi_vals = [mi_vals; fun_przyn_trap(h2, h2_lin_rozm_5, h2pp*0.25)];
            case 5
                mi_vals = [mi_vals; fun_przyn_dzwon(h2, h2_lin_rozm_5, h2pp*0.15,false)];
            case 6
                mi_vals = [mi_vals; fun_przyn_dzwon(h2, h2_lin_rozm_5, h2pp*0.2,false)];
        end
    end
    
    % Rysowanie wykresu na subplocie
    subplot(6, 1, h2_switch_num);
    hold on;
    for model=1:5
        switch model
            case 1
                plot(h2_vals, mi_vals(:,model),'-');
            case 2
                plot(h2_vals, mi_vals(:,model),'--');
            case 3
                plot(h2_vals, mi_vals(:,model),'--');
            case 4
                plot(h2_vals, mi_vals(:,model),'--');
            case 5
                plot(h2_vals, mi_vals(:,model),'--');
        end
    end
    % title(['Funkcje przynależności dla ', num2str(h2_switch_num), ' modeli']);
    xlabel('h_2');
    ylabel('mi');
    grid on;
    file_name = sprintf('wykresy/Zad2/fun_przynaleznosci_por_ksztaltow.pdf');

    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
end


tspan = [0 tk];
% Przygotowanie macierzy na błędy
errors = [];

for du_sign = [-1, 1]
    for du_per = [10, 20, 30, 40, 50]
        % Parametry skoku
        FD = FDpp;
        F1in = F1pp * (1 + du_sign * du_per / 100);

        % Symulacja modeli obiektu dla skoku sterowania
        [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
        [t_rozm1, h_rozm1] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, 0);
        [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.05);
        [t_rozm3, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.1);
        [t_rozm4, h_rozm4] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.25);
        [t_rozm5, h_rozm5] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.15, true);
        [t_rozm6, h_rozm6] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.2, true);


        % Obliczanie błędów kwadratowych (tylko na podstawie h2)
        err_rozm1 = sum((h_nlin(:, 2) - interp1(t_rozm1, h_rozm1(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm2 = sum((h_nlin(:, 2) - interp1(t_rozm2, h_rozm2(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm3 = sum((h_nlin(:, 2) - interp1(t_rozm3, h_rozm3(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm4 = sum((h_nlin(:, 2) - interp1(t_rozm4, h_rozm4(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm5 = sum((h_nlin(:, 2) - interp1(t_rozm5, h_rozm5(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm6 = sum((h_nlin(:, 2) - interp1(t_rozm6, h_rozm6(:, 2), t_nlin)).^2, 'omitnan');

        % Dodanie błędów do tabeli
        errors = [errors; du_sign * du_per, err_rozm1, err_rozm2, err_rozm3, err_rozm4, err_rozm5, err_rozm6];
    end
end

% Zapisanie błędów do pliku CSV
headers = {'Sterowanie [%]', 'Fun 1', 'Fun 2', 'Fun 3', 'Fun 4', 'Fun 5', 'Fun 6'};
file_name_csv = 'wykresy/Zad2/errors_por_modeli_rozm_5_F1in.csv';
writecell([headers; num2cell(errors)], file_name_csv);


errors = [];

for du_sign = [-1, 1]
    for du_per = [10, 20, 30, 40, 50]
        % Parametry skoku
        F1in = F1pp;
        FD = FDpp * (1 + du_sign * du_per / 100);

        % Symulacja modeli obiektu dla skoku sterowania
        [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
        [t_rozm1, h_rozm1] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, 0);
        [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.05);
        [t_rozm3, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.1);
        [t_rozm4, h_rozm4] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.25);
        [t_rozm5, h_rozm5] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.15, true);
        [t_rozm6, h_rozm6] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.2, true);

        % Obliczanie błędów kwadratowych (tylko na podstawie h2)
        err_rozm1 = sum((h_nlin(:, 2) - interp1(t_rozm1, h_rozm1(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm2 = sum((h_nlin(:, 2) - interp1(t_rozm2, h_rozm2(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm3 = sum((h_nlin(:, 2) - interp1(t_rozm3, h_rozm3(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm4 = sum((h_nlin(:, 2) - interp1(t_rozm4, h_rozm4(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm5 = sum((h_nlin(:, 2) - interp1(t_rozm5, h_rozm5(:, 2), t_nlin)).^2, 'omitnan');
        err_rozm6 = sum((h_nlin(:, 2) - interp1(t_rozm6, h_rozm6(:, 2), t_nlin)).^2, 'omitnan');

        % Dodanie błędów do tabeli
        errors = [errors; du_sign * du_per, err_rozm1, err_rozm2, err_rozm3, err_rozm4, err_rozm5, err_rozm6];
    end
end

% Zapisanie błędów do pliku CSV
headers = {'Zakłócenie [%]', 'Fun 1', 'Fun 2', 'Fun 3', 'Fun 4', 'Fun 5', 'Fun 6'};
file_name_csv = 'wykresy/Zad2/errors_por_modeli_rozm_5_FD.csv';
writecell([headers; num2cell(errors)], file_name_csv);

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

% Tworzenie nowej figury dla każdego wykresu
figure;
plot(F1in_vals, hs, 'DisplayName', 'Model nieliniowy');
hold on;
plot(F1in_vals, hsr1, '--', 'DisplayName', 'Model rozmyty 1');
plot(F1in_vals, hsr3, '--', 'DisplayName', 'Model rozmyty 3');

% Ustawienie tytułów, etykiet i siatki
xlabel('F_{1in}');
ylabel('Wysokość h_2');
legend('Model nieliniowy', 'Model rozmyty 1', 'Model rozmyty 3', 'Location','northwest');
title('Model rozmyty dla 3 funkcji przynależności');
legend;
grid on; grid minor;

% Generowanie nazwy pliku
file_name = sprintf('wykresy/Zad2/statyka_rozmyta_kszt_modeli.pdf');

% Eksport wykresu do pliku .pdf
exportgraphics(gcf, file_name, 'ContentType', 'vector');


% Inicjalizacja wektorów wyników
hs = [];
hsr1 = [];
hsr2 = [];
hsr3 = [];
hsr4 = [];
hsr5 = [];
hsr6 = [];

FD_vals = 5:0.25:25;

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





