clear all;
addpath('DMC');
%Parametry modelu
C1=0.35; C2=0.3; alpha1=20; alpha2=22; tau=150;


% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;


% Czas próbkowania i ilość iteracji
Tp=1; kk = 100;


% Wartość funkcji wejściowej
F1in_vals(1:kk) = 73;
F1in = @(t) F1pp*(t<0)+F1in_vals(max(1, ceil(t / Tp)))*(t>=0);


% Równania modelu
F1 = @(t) F1in(t-tau);
F2 = @(h1) alpha1 * sqrt(h1);
F3 = @(h2) alpha2 * sqrt(h2);
FD = @(t) FDpp*(t<0)+FDpp*(t>=0);


% Funkcje h1 i h2 wyrażone przez V1 i V2
h1 = @(V1) (V1 / C1)^(1/3);
h2 = @(V2) (V2 / C2)^(1/3);


% Równania różniczkowe modelu
odeSystemNlin = @(t, V) [
    F1(t) + FD(t) - F2(h1(V(1)));      % dV1/dt
    F2(h1(V(1))) - F3(h2(V(2)))        % dV2/dt
];

h2zad_val = 20;
h2zad = @(t) h2zad_val;

% DMC parametry
N=20; Nu=20; D=50; lambda=5;

% DMC obliczenia offline

ys=odp_jedn_fun(kk,Tp);

[K1, ke, ku, Mp] = DMC_offline(ys,N,Nu,lambda,D);


% Warunki początkowe symulacji
V1_0 = C1 * (h1pp)^3;
V2_0 = C2 * (h2pp)^3;   
V0 = [V1_0; V2_0];
V=V0';
t=0;
du_p(1:D-1)=0;
u_p=F1pp;

for k=1:kk
    t_k=k*Tp;

    h2k=h2(V0(2));

    du=DMC_du(h2k,h2zad(t_k),ke,ku,du_p');
    u=u_p+du;
    F1in_vals(k)=u;
    u_p=u;

    % Aktualizacja przeszłych przyrostów sterowania`
    for n=D-1:-1:2
        du_p(n) = du_p(n-1);
    end
    du_p(1) = du;

    tspan = [t_k-Tp t_k];

    % Rozwiąż równania ODE
    [tk, Vk] = ode45(odeSystemNlin, tspan, V0);
    V0=Vk(end,:);
    V=[V;Vk(2:end,:)];
    t=[t;tk(2:end,:)];
end


% Przekształć objętości na wysokości
h1_vals = (V(:,1) / C1).^(1/3);
h2_vals = (V(:,2) / C2).^(1/3);

% Wyświetlenie wyników
figure;
plot(t, h1_vals, '-', t, h2_vals, ':');
legend('h1(t)', 'h2(t)');
xlabel('Czas (t)');
ylabel('Wysokości (h1, h2)');
title('Rozwiązanie układu równań różniczkowych z opóźnieniem tau');
grid on;
