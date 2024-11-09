function [t, h] = skok_mod_lin(tspan, h0, Tp, F1in_vals, FD_vals, F1pp, FDpp, h_lin)
    % Parametry modelu
    C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;
    
    % Definicja funkcji sterującej
    F1in = @(t) F1pp * (t < 0) + F1in_vals(max(1, floor(t / Tp)+1)) * (t >= 0);

    % Zlinearyzowane równania modelu
    F1 = @(t) F1in(t - tau);
    F2 = @(h1) alpha1 * sqrt(h_lin(1)) + (alpha1 / (2 * sqrt(h_lin(1)))) * (h1 - h_lin(1));
    F3 = @(h2) alpha2 * sqrt(h_lin(2)) + (alpha2 / (2 * sqrt(h_lin(2)))) * (h2 - h_lin(2));
    FD = @(t) FDpp * (t < 0) + FD_vals(max(1, ceil(t / Tp))) * (t >= 0);
    
    % Funkcje h1 i h2 wyrażone przez V1 i V2
    h1 = @(V1) (V1 / C1) .^ (1/3);
    h2 = @(V2) (V2 / C2) .^ (1/3);

    odeSystemNlin = @(t, V) [
        F1(t) + FD(t) - F2(h1(V(1)));      % dV1/dt
        F2(h1(V(1))) - F3(h2(V(2)))        % dV2/dt
    ];

    V0 = [C1 * (h0(1))^3, C2 * (h0(2))^3];

    [t, V] = ode15s(odeSystemNlin, tspan, V0);
    h = [h1(V(:,1)), h2(V(:,2))];
end
