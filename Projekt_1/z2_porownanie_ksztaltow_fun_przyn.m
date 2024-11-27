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
h2_lin_rozm_5 = h2pp * [0.5; 1; 1.5; 2; 2.5];
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
                mi_vals = [mi_vals; fun_przyn_dzwon(h2, h2_lin_rozm_5, h2pp*0.15,true)];
            case 6
                mi_vals = [mi_vals; fun_przyn_dzwon(h2, h2_lin_rozm_5, h2pp*0.2,true)];
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
    title(['Funkcje przynależności dla ', num2str(h2_switch_num), ' modeli']);
    xlabel('h_2');
    ylabel('w');
    grid on;
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
        [t_rozm3, h_rozm3] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm_5, h2pp*0.15);
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
headers = {'Sterowanie [%]', '0', '0.05hpp', '0.15hpp', '0.25hpp', 'dzwon 0.05', 'dzwon 0.15'};
file_name_csv = 'wykresy/Zad2/errors_por_modeli_rozm_5_F1in.csv';
writecell([headers; num2cell(errors)], file_name_csv);
disp(['Błędy zapisano w pliku: ', file_name_csv]);
