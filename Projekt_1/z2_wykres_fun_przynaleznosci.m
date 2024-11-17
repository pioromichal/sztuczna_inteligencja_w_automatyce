addpath('funkcje_przynaleznosci\')
% Główna funkcja do wyświetlania wykresów przynależności
function plot_membership_functions(z_vals, z_switch)
    numModels = length(z_vals);            % Liczba modeli lokalnych
    % z_min = min(z_vals) - 1;               % Zakres minimalny wykresu
    % z_max = max(z_vals) + 1;               % Zakres maksymalny wykresu
    z_min = 0;               % Zakres minimalny wykresu
    z_max = 30;               % Zakres maksymalny wykresu
    z_range = linspace(z_min, z_max, 1000); % Przedział wartości 'z' dla wykresu
    
    % Tworzenie i wyświetlanie wykresów dla każdego modelu
    figure; hold on;
    colors = lines(numModels);  % Kolory dla każdego modelu

    % Obliczanie i rysowanie funkcji przynależności dla każdego modelu
    for i = 1:numModels
        mi_values = zeros(1, length(z_range));
        for j = 1:length(z_range)
            % Obliczanie przynależności dla każdego punktu z zakresu
            mi = fun_przyn_trap(z_range(j), z_vals, z_switch);
            mi_values(j) = mi(i);
        end
        
        % Rysowanie wykresu dla modelu i
        plot(z_range, mi_values, 'Color', colors(i,:), 'DisplayName', sprintf('Model %d', i), 'LineWidth', 1.5);
    end
    
    % Ustawienia wykresu
    xlabel('z');
    ylabel('Przynależność');
    title('Funkcje przynależności trapezoidalne');
    legend('show');
    grid on;
    hold off;
end

% Przykładowe użycie
z_vals = [5;15;25];  % Wartości centralne dla modeli lokalnych
z_switch = 5;              % Szerokość płaskiego fragmentu trapezu
plot_membership_functions(z_vals, z_switch);
