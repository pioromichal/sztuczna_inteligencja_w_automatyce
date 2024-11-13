function y = fun_trojkatna(x, a, b, c)
    % FUN_TROJKATNA Oblicza wartość funkcji przynależności o kształcie trójkątnym.
    % 
    % Argumenty:
    %   x - wartość, dla której obliczana jest przynależność (punkt wejściowy).
    %   a - początek trójkąta (lewy kraniec przedziału), gdzie funkcja przynależności wynosi 0.
    %   b - środek trójkąta (punkt szczytowy), gdzie funkcja przynależności wynosi 1.
    %   c - koniec trójkąta (prawy kraniec przedziału), gdzie funkcja przynależności wraca do 0.
    %
    % Zwraca:
    %   y - stopień przynależności wartości x do trójkątnego zbioru rozmytego.
    
    if x == b
        y = 1;  % Wartość 1 dla x == b
    elseif x <= a || x >= c
        y = 0;  % Poza zakresem trójkąta
    elseif x < b
        y = (x - a) / (b - a);  % Wzrost funkcji
    else
        y = (c - x) / (c - b);  % Spadek funkcji
    end
end
