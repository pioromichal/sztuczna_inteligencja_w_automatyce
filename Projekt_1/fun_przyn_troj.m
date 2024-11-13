function [mi] = fun_przyn_troj(z, z_min, z_max, numModels)
    % FUN_PRZYN_TROJ Oblicza wartości funkcji przynależności trójkątnej dla
    % danego parametru na podstawie równomiernie rozmieszczonych modeli lokalnych.
    %
    % Argumenty:
    %   z         - Wartość wejściowa parametru (np. sterowanie lub wyjście),
    %               dla którego obliczana jest przynależność do każdego modelu lokalnego.
    %   z_min     - Minimalna wartość zakresu parametru, wyznaczająca początek funkcji przynależności.
    %   z_max     - Maksymalna wartość zakresu parametru, wyznaczająca koniec funkcji przynależności.
    %   numModels - Liczba modeli lokalnych (zbiorów rozmytych), dla których zostaną wyznaczone wartości funkcji przynależności.
    %
    % Zwraca:
    %   mi - Wektor zawierający wartości funkcji przynależności dla każdego z modeli lokalnych,
    %        przy czym każda wartość określa stopień przynależności `z` do danego modelu.
    
    krok = (z_max - z_min) / (numModels - 1);
    srodek = z_min:krok:z_max;
    
    % Inicjalizacja wektora mi
    mi = zeros(1, numModels);
    
    % Ustawienie wartości 'z' poza zakresem na wartość graniczną
    z = max(z_min, min(z, z_max));
    
    for i = 1:numModels
        % Ustawienie punktów 'a', 'b', 'c' dla funkcji trójkątnej
        a = srodek(max(1, i - 1));
        b = srodek(i);
        c = srodek(min(numModels, i + 1));

        % Wyznaczenie przynależności
        mi(i) = fun_trojkatna(z, a, b, c);
    end
end
