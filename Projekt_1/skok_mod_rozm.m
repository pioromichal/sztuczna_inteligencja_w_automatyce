% function [t, h] = skok_mod_rozm(tspan, h0, Tp, F1in_vals, FD_vals, F1pp, FDpp, numModels, h_lin)
%     % h_lin = h_min:((h_max-h_min)/(numModels-1)):h_max;
%     C1 = 0.35; C2 = 0.3;
%     h2_min=h_lin(1,2);
%     h2_max=h_lin(end,2);
%     % F1 = cell(1, numModels);
%     F2 = cell(1, numModels);
%     F3 = cell(1, numModels);
%     % FD = cell(1, numModels);
%     % h1 = cell(1, numModels);
%     % h2 = cell(1, numModels);
%     % 
%     for i = 1:numModels 
%         [F1{i}, F2{i}, F3{i}, FD{i}, h1{i}, h2{i}] = mod_lin(F1pp, FDpp, F1in_vals, FD_vals, Tp, h_lin(i, :));
%     end
% 
%     F1_rozm = @(t) F1{1}(t);
%     F2_rozm = @(h1, mi) sum(arrayfun(@(i) mi(i) * F2{i}(h1), 1:numModels));
%     F3_rozm = @(h2, mi) sum(arrayfun(@(i) mi(i) * F3{i}(h2), 1:numModels));
%     FD_rozm = @(t) FD{1}(t);
%     h1_rozm = @(V1) h1{1}(V1);
%     h2_rozm = @(V2) h2{1}(V2);
% 
%     dV1dt=@(t, V, mi) F1_rozm(t) + FD_rozm(t) - F2_rozm(h1_rozm(V(1)), mi);
%     dv2dt=@(t, V, mi) F2_rozm(h1_rozm(V(1)), mi) - F3_rozm(h2_rozm(V(2)), mi);
%     odeSystemRozm = @(t, V) [
%         dV1dt(t, V, fun_przyn_troj(h2_rozm(V(2)),h2_min,h2_max,numModels));     % dV1/dt
%         dv2dt(t, V, fun_przyn_troj(h2_rozm(V(2)),h2_min,h2_max,numModels))    % dV2/dt
%     ];
% 
% 
% 
%     V0 = [C1 * (h0(1))^3, C2 * (h0(2))^3];
% 
%     [t, V] = ode15s(odeSystemRozm, tspan, V0);
% 
%     h = [h1_rozm(V(:,1)), h2_rozm(V(:,2))];
% 
% end



function [t, h] = skok_mod_rozm(tspan, h0, Tp, F1in_vals, FD_vals, F1pp, FDpp, numModels, h_lin)
    % Parametry modelu
    C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;
    
    % Definicja funkcji sterującej
    F1in = @(t) F1pp * (t < 0) + F1in_vals(max(1, floor(t / Tp)+1)) * (t >= 0);

    % Zlinearyzowane równania modelu
    F1 = @(t) F1in(t - tau);
    FD = @(t) FDpp * (t < 0) + FD_vals(max(1, ceil(t / Tp))) * (t >= 0);
    
    % Funkcje h1 i h2 wyrażone przez V1 i V2
    h1 = @(V1) (V1 / C1) .^ (1/3);
    h2 = @(V2) (V2 / C2) .^ (1/3);

    % Zlinearyzowane równania modelu
    F2_lin = @(h1, h_l) alpha1 * sqrt(h_l(1)) + (alpha1 / (2 * sqrt(h_l(1)))) * (h1 - h_l(1));
    F3_lin = @(h2, h_l) alpha2 * sqrt(h_l(2)) + (alpha2 / (2 * sqrt(h_l(2)))) * (h2 - h_l(2));
    
    % Rozmyte równania modelu
    F2 = @(h1, mi) sum(mi .* arrayfun(@(i) F2_lin(h1, h_lin(i, :)), 1:size(h_lin, 1)));
    F3 = @(h2, mi) sum(mi .* arrayfun(@(i) F3_lin(h2, h_lin(i, :)), 1:size(h_lin, 1)));

    % Ograniczenia dla funkcji przynależności
    h2_min=h_lin(1,2);
    h2_max=h_lin(end,2);

    % Równania różniczkowe równania
    dV1dt=@(t, V, mi) F1(t) + FD(t) - F2(h1(V(1)), mi);
    dv2dt=@(t, V, mi) F2(h1(V(1)), mi) - F3(h2(V(2)), mi);

    % odeSystemRozm = @(t, V) [
    %     dV1dt(t, V, fun_przyn_troj(h2(V(2)),h2_min,h2_max,numModels));     % dV1/dt
    %     dv2dt(t, V, fun_przyn_troj(h2(V(2)),h2_min,h2_max,numModels))    % dV2/dt
    % ];

    odeSystemRozm = @(t, V) [
        dV1dt(t, V, fun_przyn_trap(h2(V(2)),h_lin(:,2), 0));     % dV1/dt
        dv2dt(t, V, fun_przyn_trap(h2(V(2)),h_lin(:,2), 0));     % dV2/dt
    ];

    % Zmienne stanu w punkcie począkowym
    V0 = [C1 * (h0(1))^3, C2 * (h0(2))^3];
    
    % Symulacja modelu ciągłego
    [t, V] = ode15s(odeSystemRozm, tspan, V0);
    
    % Obliczenie wartości wyjść dla każdej chwili t
    h = [h1(V(:,1)), h2(V(:,2))];

end

    % odeSystemRozm = @(t, V) [
    %     dV1dt(t, V, fun_przyn_troj(F1_rozm(t),F1pp-50,F1pp+50,numModels));     % dV1/dt
    %     dv2dt(t, V, fun_przyn_troj(F1_rozm(t),F1pp-50,F1pp+50,numModels))    % dV2/dt
    % ];