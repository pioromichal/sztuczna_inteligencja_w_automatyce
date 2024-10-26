clear all;
% Parametry
C1 = 0.35;
C2 = 0.3;
alpha1 = 20;
alpha2 = 22;
FDpp = 14;
F1pp = 73;
h2pp = 15.6384;
tau = 150;  % Opóźnienie
h1pp = 18.9225;

% Definicje linearyzowanych funkcji wokół h1pp i h2pp
F1in = @(t) F1pp * (t < 0) + 80 * (t >= 0);  % Zmiana F1in po t = 0
F1 = @(t) F1in(t - tau);  % Uwzględnienie opóźnienia tau

% Linearyzacja F2 i F3 w punktach h1pp i h2pp
F2 = @(h1) alpha1 * sqrt(h1pp) + (alpha1 / (2 * sqrt(h1pp))) * (h1 - h1pp);  % Linearyzacja F2
F3 = @(h2) alpha2 * sqrt(h2pp) + (alpha2 / (2 * sqrt(h2pp))) * (h2 - h2pp);  % Linearyzacja F3

FD = @(t) FDpp;  % Stałe FD

% Funkcje h1 i h2 wyrażone przez V1 i V2 (funkcje odwrotne)
h1 = @(V1) (V1 / C1).^(1/3);  % Funkcja odwrotna do V1 = C1 * h1^3
h2 = @(V2) (V2 / C2).^(1/3);  % Funkcja odwrotna do V2 = C2 * h2^3

% Układ równań różniczkowych w postaci V1 i V2 (zlinearyzowany model)
odeSystemLinear = @(t, V) [
    F1(t) + FD(t) - F2(h1(V(1)));  % dV1/dt (zlinearyzowane)
    F2(h1(V(1))) - F3(h2(V(2)))   % dV2/dt (zlinearyzowane)
];

% Warunki początkowe - objętości V1_0 i V2_0 obliczone z h1pp i h2pp
V1_0 = C1 * (h1pp)^3;  % Początkowa objętość V1 odpowiadająca h1pp = 18.9225
V2_0 = C2 * (h2pp)^3;  % Początkowa objętość V2 odpowiadająca h2pp = 15.6384

V0 = [V1_0; V2_0];  % Wektor warunków początkowych

% Zakres czasu symulacji
tspan = [0 2000];

% Rozwiąż układ równań ODE (zlinearyzowany model)
[t, V] = ode45(odeSystemLinear, tspan, V0);

% Przekształć objętości na wysokości h1 i h2
h1_vals = (V(:,1) / C1).^(1/3);  % Oblicz h1 z V1
h2_vals = (V(:,2) / C2).^(1/3);  % Oblicz h2 z V2

% Wyświetlenie wyników na wykresie
figure;
plot(t, h1_vals, '-', 'DisplayName', 'h1(t) (zlinearyzowane)');
hold on;
plot(t, h2_vals, ':', 'DisplayName', 'h2(t) (zlinearyzowane)');
legend('Location', 'best');
xlabel('Czas (t)');
ylabel('Wysokości (h1, h2)');
title('Zlinearyzowane rozwiązanie układu równań różniczkowych z opóźnieniem \tau');
grid on;
