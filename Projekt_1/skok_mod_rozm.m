function [t, h] = skok_mod_rozm(tspan, h0, Tp, F1in_vals, FD_vals, ...
    h2_lin_rozm, reg_switch_zak)
    % Parametry modelu
    C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

    % Punkt pracy
    FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

    % Punkt linearyzacji
    h1_lin_rozm = h2_lin_rozm*(alpha2/alpha1)^2;
    
    % Definicja funkcji sterującej
    F1in = @(t) F1pp * (t <= 0) + F1in_vals(max(1, floor(t / Tp)+1)) * (t > 0);

    % Zlinearyzowane równania modelu
    F1 = @(t) F1in(t - tau);
    FD = @(t) FDpp * (t <= 0) + FD_vals(max(1, ceil(t / Tp))) * (t > 0);
    
    % Funkcje h1 i h2 wyrażone przez V1 i V2
    h1 = @(V1) (max(V1 / C1, 0)) .^ (1/3);
    h2 = @(V2) (max(V2 / C2, 0)) .^ (1/3);

    % Zlinearyzowane równania modelu
    F2_lin = @(h1, h_l) alpha1 * sqrt(h_l) + (alpha1 / (2 * sqrt(h_l))) * (h1 - h_l);
    F3_lin = @(h2, h_l) alpha2 * sqrt(h_l) + (alpha2 / (2 * sqrt(h_l))) * (h2 - h_l);
    
    % Rozmyte równania modelu
    % F2 = @(h1, mi) sum(mi .* arrayfun(@(i) F2_lin(h1, h1_lin_rozm(i)), 1:size(h1_lin_rozm, 1)));
    % F3 = @(h2, mi) sum(mi .* arrayfun(@(i) F3_lin(h2, h2_lin_rozm(i)), 1:size(h2_lin_rozm, 1)));
    F2 = @(h1, mi) mi * arrayfun(@(i) F2_lin(h1, h1_lin_rozm(i)), 1:size(h1_lin_rozm, 1))';
    F3 = @(h2, mi) mi * arrayfun(@(i) F3_lin(h2, h2_lin_rozm(i)), 1:size(h2_lin_rozm, 1))';
    

    % Równania różniczkowe równania
    dV1dt=@(t, V, mi) F1(t) + FD(t) - F2(h1(V(1)), mi);
    dV2dt=@(t, V, mi) F2(h1(V(1)), mi) - F3(h2(V(2)), mi);


    odeSystemRozm = @(t, V) [
        dV1dt(t, V, fun_przyn_trap(h2(V(2)),h2_lin_rozm, reg_switch_zak));     % dV1/dt
        dV2dt(t, V, fun_przyn_trap(h2(V(2)),h2_lin_rozm, reg_switch_zak));     % dV2/dt
    ];

    % Zmienne stanu w punkcie począkowym
    V0 = [C1 * (h0(1))^3, C2 * (h0(2))^3];
    
    % Symulacja modelu ciągłego
    [t, V] = ode15s(odeSystemRozm, tspan, V0);
    
    % Obliczenie wartości wyjść dla każdej chwili t
    h = [h1(V(:,1)), h2(V(:,2))];

end