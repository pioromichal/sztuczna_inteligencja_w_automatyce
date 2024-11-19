clear all;

% Parametry modelu
C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

% Punkt pracy
FDpp = 14; 
h2pp = 15.6384 * 1.5; 
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

options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
[F1pp_opt, fval] = fmincon(fun, F1pp0, [], [], [], [], F1pp_min, F1pp_max, [], options);

% Wyświetlenie optymalnej wartości
fprintf('Optymalna wartość F1pp: %.4f\n', F1pp_opt);
fprintf('Minimalny błąd: %.4f\n', fval);

% Symulacja dla optymalnej wartości F1pp
[t, h] = skok_mod_lin(tspan, h0, tk, F1pp_opt, FDpp, h_lin, F1pp_opt);

% Rysowanie wyników
figure;
plot(t, h(:,1), '-', t, h(:,2), '--');
legend('h1', 'h2');
xlabel('Czas (t)');
ylabel('Wysokość');
title('Wykres odpowiedzi dla optymalnego F1pp');
grid on; grid minor;

% Funkcja celu do optymalizacji
function error = compute_error(F1pp, tspan, h0, tk, FD, h2_lin, h2pp, h1pp)
    % Symulacja modelu liniowego
    [~, h] = skok_mod_lin(tspan, h0, tk, F1pp, FD, h2_lin, F1pp);
    % Obliczenie błędu jako suma kwadratów różnic
    error = sum((h(:,1) - h1pp).^2 + (h(:,2) - h2pp).^2);
end
