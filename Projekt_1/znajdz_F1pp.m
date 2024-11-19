function [F1pp_opt] = znajdz_F1pp(h2pp)
    % Parametry modelu
    C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;
    
    % Punkt pracy
    FDpp = 14; 
    h1pp = h2pp * (alpha2 / alpha1)^2; % h1pp = 18.9225
    
    % Parametry symulacji
    tk = 2000; 
    tspan = [0 tk];
    h0 = [h1pp h2pp]; 
    h_lin = h2pp;
    
    % Optymalizacja F1pp
    fun = @(F1pp) compute_error(F1pp, tspan, h0, tk, FDpp, h_lin, h2pp, h1pp);
    
    % Ograniczenia dla F1pp
    F1pp_min = 10; % Minimalna wartość
    F1pp_max = 150; % Maksymalna wartość
    F1pp0 = 73;    % Początkowa wartość
    
    options = optimoptions('fmincon', 'Display', 'none', 'Algorithm', 'sqp');
    [F1pp_opt, ~] = fmincon(fun, F1pp0, [], [], [], [], F1pp_min, F1pp_max, [], options);
end

% Funkcja celu do optymalizacji
function error = compute_error(F1pp, tspan, h0, tk, FD, h2_lin, h2pp, h1pp)
    % Symulacja modelu liniowego
    [~, h] = skok_mod_lin(tspan, h0, tk, F1pp, FD, h2_lin, F1pp);
    % Obliczenie błędu jako suma kwadratów różnic
    error = sum((h(:,1) - h1pp).^2 + (h(:,2) - h2pp).^2);
end
