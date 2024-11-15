clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;
 
% Parametry skoku
FD=FDpp;
F1in=80;

% Parametry symulacji
tk=2000;
tspan=[0 tk];
h0=[h1pp h2pp];

% Symulacja skoku sterowania
[t, h] = skok_mod_lin(tspan, h0, tk, F1in, FD, h0);

h1_vals=h(:,1);
h2_vals=h(:,2);


% Wyświetlenie wyników
figure;
plot(t, h1_vals, '-', t, h2_vals, ':');
legend('h1(t)', 'h2(t)');
xlabel('Czas (t)');
ylabel('Wysokości (h1, h2)');
title(['Symulacja modelu liniowego po skoku sterowania F_{1in}=', num2str(F1in)]);
grid on;