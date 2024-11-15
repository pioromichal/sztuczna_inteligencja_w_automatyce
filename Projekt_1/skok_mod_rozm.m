function [t, h] = skok_mod_rozm(tspan, h0, Tp, F1in_vals, FD_vals, h_lin, reg_switch_zak)
    % Parametry modelu
    C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

    % Punkt pracy
    FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;
    
    % Definicja funkcji sterującej
    F1in = @(t) F1pp * (t <= 0) + F1in_vals(max(1, floor(t / Tp)+1)) * (t > 0);

    % Zlinearyzowane równania modelu
    F1 = @(t) F1in(t - tau);
    FD = @(t) FDpp * (t <= 0) + FD_vals(max(1, ceil(t / Tp))) * (t > 0);
    
    % Funkcje h1 i h2 wyrażone przez V1 i V2
    h1 = @(V1) (V1 / C1) .^ (1/3);
    h2 = @(V2) (V2 / C2) .^ (1/3);

    % Zlinearyzowane równania modelu
    F2_lin = @(h1, h_l) alpha1 * sqrt(h_l(1)) + (alpha1 / (2 * sqrt(h_l(1)))) * (h1 - h_l(1));
    F3_lin = @(h2, h_l) alpha2 * sqrt(h_l(2)) + (alpha2 / (2 * sqrt(h_l(2)))) * (h2 - h_l(2));
    
    % Rozmyte równania modelu
    F2 = @(h1, mi) sum(mi .* arrayfun(@(i) F2_lin(h1, h_lin(i, :)), 1:size(h_lin, 1)));
    F3 = @(h2, mi) sum(mi .* arrayfun(@(i) F3_lin(h2, h_lin(i, :)), 1:size(h_lin, 1)));

    % % Ograniczenia dla funkcji przynależności
    % h2_min=h_lin(1,2);
    % h2_max=h_lin(end,2);

    % Równania różniczkowe równania
    dV1dt=@(t, V, mi) F1(t) + FD(t) - F2(h1(V(1)), mi);
    dV2dt=@(t, V, mi) F2(h1(V(1)), mi) - F3(h2(V(2)), mi);


    odeSystemRozm = @(t, V) [
        dV1dt(t, V, fun_przyn_trap(h2(V(2)),h_lin(:,2), reg_switch_zak));     % dV1/dt
        dV2dt(t, V, fun_przyn_trap(h2(V(2)),h_lin(:,2), reg_switch_zak));     % dV2/dt
    ];

    % Zmienne stanu w punkcie począkowym
    V0 = [C1 * (h0(1))^3, C2 * (h0(2))^3];
    
    % Symulacja modelu ciągłego
    [t, V] = ode15s(odeSystemRozm, tspan, V0);
    
    % Obliczenie wartości wyjść dla każdej chwili t
    h = [h1(V(:,1)), h2(V(:,2))];

end