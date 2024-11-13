function [mi] = fun_przyn_trap(z, z_vals, z_switch)
    % FUN_PRZYN_TRAP Oblicza wartości funkcji przynależności trapezowej dla
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
    
    % krok = (z_max - z_min) / (numModels - 1);
    % srodek = z_min:krok:z_max;
    % 

    numModels=length(z_vals);

    
    
    % Ustawienie wartości 'z' poza zakresem na wartość graniczną
    if z < min(z_vals)
        mi = [1 zeros(1, numModels-1)];
    elseif z > max(z_vals)
        mi = [zeros(1, numModels-1) 1];
    else
        % Inicjalizacja wektora mi
        mi = zeros(1, numModels);
        for i = 1:numModels
            % Ustawienie punktów 'a', 'b', 'c', 'd' dla funkcji trapezowej
            if i == 1
                % Lewy kraniec
                a = z_vals(1)-1;
                b = z_vals(1);
                c = z_vals(i)+(z_vals(i+1)-z_vals(i))/2-z_switch/2;
                d = z_vals(i)+(z_vals(i+1)-z_vals(i))/2+z_switch/2;
            elseif i == numModels
                % Prawy kraniec
                a = z_vals(i)-(z_vals(i)-z_vals(i-1))/2-z_switch/2;
                b = z_vals(i)-(z_vals(i)-z_vals(i-1))/2+z_switch/2;
                c = z_vals(i);
                d = z_vals(i)+1;
            else
                % Środkowe modele
                a = z_vals(i)-(z_vals(i)-z_vals(i-1))/2-z_switch/2;
                b = z_vals(i)-(z_vals(i)-z_vals(i-1))/2+z_switch/2;
                c = z_vals(i)+(z_vals(i+1)-z_vals(i))/2-z_switch/2;
                d = z_vals(i)+(z_vals(i+1)-z_vals(i))/2+z_switch/2;
            end
    
            % Wyznaczenie przynależności
            mi(i) = fun_trapezowa(z, a, b, c, d);
        end
    end
end
