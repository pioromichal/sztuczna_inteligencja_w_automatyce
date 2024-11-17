function [t, h] = skok_mod_lin(tspan, h0, Tp, F1in_vals, FD_vals, h2_lin)
    % Parametry modelu
    C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

    % Punkt pracy
    FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

    % Punkt linearyzacji
    h1_lin = h2_lin*(alpha2/alpha1)^2;
    
    % Definicja funkcji sterującej
    F1in = @(t) F1pp * (t <= 0) + F1in_vals(max(1, ceil(t / Tp))) * (t > 0);

    % Zlinearyzowane równania modelu
    F1 = @(t) F1in(t - tau);
    F2 = @(h1) alpha1 * sqrt(h1_lin) + (alpha1 / (2 * sqrt(h1_lin))) * (h1 - h1_lin);
    F3 = @(h2) alpha2 * sqrt(h2_lin) + (alpha2 / (2 * sqrt(h2_lin))) * (h2 - h2_lin);
    FD = @(t) FDpp * (t <= 0) + FD_vals(max(1, ceil(t / Tp))) * (t > 0);
    
    % Funkcje h1 i h2 wyrażone przez V1 i V2
    h1 = @(V1) (max(V1 / C1, 0)) .^ (1/3);
    h2 = @(V2) (max(V2 / C2, 0)) .^ (1/3);

    odeSystemLin = @(t, V) [
        F1(t) + FD(t) - F2(h1(V(1)));      % dV1/dt
        F2(h1(V(1))) - F3(h2(V(2)))        % dV2/dt
    ];

    V0 = [C1 * (h0(1))^3, C2 * (h0(2))^3];

    [t, V] = ode15s(odeSystemLin, tspan, V0);
    h = [h1(V(:,1)), h2(V(:,2))];
end
