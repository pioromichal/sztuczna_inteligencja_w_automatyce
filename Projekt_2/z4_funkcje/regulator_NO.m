function [y, u, E] = regulator_NO(N, Nu, lambda, ...
    umin, umax, dumult, yzad, w10, w1, w20, w2)
    % Ograniczenia zmienności sterwoania

    dumax = (umax-umin)*dumult;

    kk = length(yzad);

    % Inicjalizacja zmiennych
    x1km1 = 0;
    x2km1 = 0;
    y = zeros(1, kk);
    u = zeros(1, kk);
    du = zeros(Nu, 1);
    du_opt = zeros(Nu, 1);
    lb = repmat(-dumax, Nu, 1);
    ub = repmat(dumax, Nu, 1);

    % Opcje dla fmincon
    options = optimoptions('fmincon', 'Display', 'off', ...
        'Algorithm', 'interior-point');

    % Pętla optymalizacji
    for k = 7:kk
        % pomiar (symulacja) y(k)
        [x1km1, x2km1, y(k)] = symulacja_procesu(x1km1, x2km1, u(k-5));
    
        % Obliczanie zakłócenia dk
        dk = y(k) - model_neuron(u(k-5), u(k-6), y(k-1), y(k-2), ...
            w10, w1, w20, w2);
    
        % Funkcje do fminocona
        fun = @(du) funkcja_celu_NO(du, k, u, y, yzad(k), dk, ...
            w10, w1, w20, w2, N, Nu, lambda);
        ograniczenia_fun = @(du) ograniczenia_NO(du,u,umin,umax,k);
        
        % Przeprowadzenie optymalizacji
        du = [du_opt(2:Nu);du_opt(Nu)];
        [du_opt, fval] = fmincon(fun, du, [], [], [], [], lb, ub, ...
            ograniczenia_fun, options);  % Optymalizacja
        fprintf('Iteracja %d: Błąd = %.4f\n', k, fval);
        % Zaktualizowanie sterowania
        u(k) = u(k-1) + du_opt(1);  % Zastosowanie optymalnego sterowania
    end

    % Obliczanie błędu globalnego
    E = sum((yzad - y).^2);
end