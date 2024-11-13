function [F1, F2, F3, FD, h1, h2]=mod_lin(F1pp, FDpp, F1in_vals, FD_vals, Tp, h_lin)

    % Parametry modelu
    C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

    % Definicja funkcji sterującej
    F1in = @(t) F1pp * (t < 0) + F1in_vals(max(1, floor(t / Tp)+1)) * (t >= 0);
    F1 = @(t) F1in(t - tau);
    FD = @(t) FDpp * (t < 0) + FD_vals(max(1, ceil(t / Tp))) * (t >= 0);

    % Zlinearyzowane równania modelu
    F2 = @(h1) alpha1 * sqrt(h_lin(1)) + (alpha1 / (2 * sqrt(h_lin(1)))) * (h1 - h_lin(1));
    F3 = @(h2) alpha2 * sqrt(h_lin(2)) + (alpha2 / (2 * sqrt(h_lin(2)))) * (h2 - h_lin(2));
    
    % Funkcje h1 i h2 wyrażone przez V1 i V2
    h1 = @(V1) (V1 / C1) .^ (1/3);
    h2 = @(V2) (V2 / C2) .^ (1/3);

end