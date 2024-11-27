clear all;
addpath('funkcje_przynaleznosci');

h2pp = 15.6384;

h2_lin_rozm_2=h2pp*[1; 1.5];
h2_lin_rozm_3=h2pp*[0.5;1;1.5];
h2_lin_rozm_4=h2pp*[0.75;1;1.25;1.5];
h2_lin_rozm_5=h2pp*[0.5;0.75;1;1.25;1.5];

z_switch = 0;
z_vals = linspace(0.4 * h2pp, 1.6 * h2pp, 500);

figure;
for models_num = 2:5
    mi_vals = [];
    for z = z_vals
        % Wybór odpowiednich wartości na podstawie liczby modeli
        switch models_num
            case 2
                mi_vals = [mi_vals; fun_przyn_trap(z, h2_lin_rozm_2, z_switch)];
            case 3
                mi_vals = [mi_vals; fun_przyn_trap(z, h2_lin_rozm_3, z_switch)];
            case 4
                mi_vals = [mi_vals; fun_przyn_trap(z, h2_lin_rozm_4, z_switch)];
            case 5
                mi_vals = [mi_vals; fun_przyn_trap(z, h2_lin_rozm_5, z_switch)];
    end
    
    % Rysowanie wykresu na subplocie
    subplot(4, 1, models_num-1);
    hold on;
    for model=1:models_num
        switch model
            case 1
                plot(z_vals, mi_vals(:,model),'-');
            case 2
                plot(z_vals, mi_vals(:,model),'--');
            case 3
                plot(z_vals, mi_vals(:,model),'-.');
            case 4
                plot(z_vals, mi_vals(:,model),':');
            case 5
                plot(z_vals, mi_vals(:,model),':');
        end
    end
    title(['Funkcje przynależności dla ', num2str(models_num), ' modeli']);
    xlabel('h_2');
    ylabel('w');
    grid on;
end
% Generowanie nazwy pliku
file_name = sprintf('wykresy/Zad2/fun_przyn_por_modeli.pdf');

% Export wykresu do pliku .pdf
exportgraphics(gcf, file_name, 'ContentType', 'vector');