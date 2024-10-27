function [h1_vals, h2_vals, t]=odp_skok_mod_lin(F1in_val, FD_val, kk, Tp)


%Parametry modelu
C1=0.35; C2=0.3; alpha1=20; alpha2=22; tau=150;


% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;


% Wartość funkcji wejściowych
F1in_vals(1:kk) = F1in_val;
F1in = @(t) F1pp*(t<0)+F1in_vals(max(1, ceil(t / Tp)))*(t>=0);
FD = @(t) FDpp*(t<0)+FD_val*(t>=0);


% Zlinearyzowane równania modelu
F1 = @(t) F1in(t-tau);
F2 = @(h1) alpha1 * sqrt(h1pp) + (alpha1 / (2 * sqrt(h1pp))) * (h1 - h1pp);
F3 = @(h2) alpha2 * sqrt(h2pp) + (alpha2 / (2 * sqrt(h2pp))) * (h2 - h2pp);


% Funkcje h1 i h2 wyrażone przez V1 i V2 (funkcje odwrotne)
h1 = @(V1) (V1 / C1).^(1/3);
h2 = @(V2) (V2 / C2).^(1/3);


% Układ zlinearyzowanych równań różniczkowych modelu
odeSystemLin = @(t, V) [
    F1(t) + FD(t) - F2(h1(V(1)));  % dV1/dt (zlinearyzowane)
    F2(h1(V(1))) - F3(h2(V(2)))   % dV2/dt (zlinearyzowane)
];


% Warunki początkowe symulacji
V1_0 = C1 * (h1pp)^3;
V2_0 = C2 * (h2pp)^3;   
V0 = [V1_0; V2_0];
V=V0';
t=0;


for k=1:kk
    t_k=k*Tp;

    tspan = [t_k-Tp t_k];

    % Rozwiąż równania ODE
    [tk, Vk] = ode45(odeSystemLin, tspan, V0);
    V0=Vk(end,:);
    V=[V;Vk(2:end,:)];
    t=[t;tk(2:end,:)];
end


% Przekształenie objętości na wysokości
h1_vals = (V(:,1) / C1).^(1/3);
h2_vals = (V(:,2) / C2).^(1/3);

end
