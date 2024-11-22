function [mi] = fun_przyn_trap(z, z_vals, z_switch)
    % FUN_PRZYN_TRAP Oblicza wartości funkcji przynależności trapezowej
    % dla danego parametru `z`, wykorzystując zadane punkty centralne `z_vals`.
    % Funkcja modeluje stopień przynależności do zbiorów rozmytych w oparciu 
    % o równomiernie rozmieszczone punkty centralne (modele lokalne).
    %
    % Argumenty wejściowe:
    %   z        - Wartość wejściowa (np. sterowanie lub wyjście), 
    %              dla której obliczana jest przynależność do każdego zbioru rozmytego.
    %   z_vals   - Wektor wartości centralnych dla każdego zbioru rozmytego (środków funkcji trapezowych).
    %   z_switch - Długość strefy przejściowej (część nachylona trapezu), 
    %              kontrolująca szerokość funkcji przynależności.
    %
    % Zwraca:
    %   mi - Wektor o długości równej liczbie modeli lokalnych (numel(z_vals)),
    %        zawierający stopnie przynależności wartości `z` do każdego modelu lokalnego.
   
    % Liczba Modeli
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
