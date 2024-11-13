function y = fun_trapezowa(x, a, b, c, d)
    % FUN_TRAPEZOWA Oblicza wartość funkcji przynależności o kształcie
    % trapezowym lub prostokątnym prawostronnie domkniętym
    % 
    % Argumenty:
    %   x - wartość, dla której obliczana jest przynależność (punkt wejściowy).
    %   a - początek trapezu (lewy kraniec przedziału), gdzie funkcja przynależności wynosi 0.
    %   b - początek płaskiej części trapezu, gdzie funkcja przynależności zaczyna wynosić 1.
    %   c - koniec płaskiej części trapezu, gdzie funkcja przynależności zaczyna spadać z 1.
    %   d - koniec trapezu (prawy kraniec przedziału), gdzie funkcja przynależności wraca do 0.
    %
    % Zwraca:
    %   y - stopień przynależności wartości x do trapezoidalnego zbioru rozmytego.

    if x <= a || x > d
        y = 0;  % Poza zakresem trapezu
    elseif x >= b && x <= c
        y = 1;  % W płaskiej części trapezu
    elseif x > a && x < b
        y = (x - a) / (b - a);  % Wzrost funkcji
    else  % x > c && x < d
        y = (d - x) / (d - c);  % Spadek funkcji
    end
end
