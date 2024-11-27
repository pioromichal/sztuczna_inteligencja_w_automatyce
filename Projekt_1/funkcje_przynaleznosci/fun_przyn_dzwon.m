function [mi] = fun_przyn_dzwon(z, z_vals, z_switch, varargin)
    % FUN_PRZYN_DZWONOWA_SWITCH Oblicza wartości funkcji przynależności dzwonowej
    % na podstawie punktów przełączania (z_switch) i punktów środkowych (z_vals).
    %
    % Argumenty:
    %   z         - Wartość wejściowa parametru (np. sterowanie lub wyjście).
    %   z_switch  - Wektor punktów przełączania (granice między zakresami modeli).
    %   z_vals    - Wektor środkowych wartości dla każdego modelu lokalnego.
    %
    % Zwraca:
    %   mi - Wektor zawierający wartości funkcji przynależności dla każdego z modeli lokalnych.
    if nargin>=4
        normal=varargin{1};
    else
        normal=false;
    end

    numModels = length(z_vals);  % Liczba modeli lokalnych
    mi = zeros(1, numModels);    % Inicjalizacja wektora przynależności
    
    % Sprawdzenie, do którego zakresu należy z

    for i = 1:numModels
        c = z_vals(i);                         % Punkt środkowy
        z_odl=(max(z_vals)-min(z_vals))/(numModels-1);
        % Oblicz szerokość funkcji na podstawie punktów przełączania
        a = z_odl-z_switch;  % Szerokość funkcji
        b = z_switch;                                 % Ostrość (przykładowa wartość)
        
        % Oblicz funkcję dzwonową
        mi(i) = 1 / (1 + abs((z - c) / a)^(2 * b));
    end
    if z < min(z_vals)
        mi(1) = 1;
    elseif z > max(z_vals)
        mi(numModels)=1;
    end
    if normal
        mi=mi/sum(mi);
    end
end
