function [mi] = fun_przyn_sigmoid(z, z_vals, a)
    % FUN_PRZYN_SIGMOID Oblicza wartości funkcji przynależności sigmoidalnej dla
    % danego parametru na podstawie równomiernie rozmieszczonych modeli lokalnych.
    %
    % Argumenty:
    %   z         - Wartość wejściowa parametru (np. sterowanie lub wyjście),
    %               dla którego obliczana jest przynależność do każdego modelu lokalnego.
    %   z_vals    - Wartości punktów środkowych dla każdego modelu lokalnego.
    %   a         - Parametr szerokości funkcji sigmoidalnej (kontroluje "ostrość" przejścia).
    %
    % Zwraca:
    %   mi - Wektor zawierający wartości funkcji przynależności dla każdego z modeli lokalnych.
    
    numModels = length(z_vals);  % Liczba lokalnych modeli
    mi = zeros(1, numModels);    % Inicjalizacja wektora przynależności
    
    % Obliczenie przynależności dla każdego modelu lokalnego
    for i = 1:numModels
        c = z_vals(i);  % Środek funkcji sigmoidalnej
        mi(i) = 1 / (1 + exp(-(z - c) / a));  % Funkcja sigmoidalna
    end
end
