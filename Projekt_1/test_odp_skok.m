clear all;

C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;
% Punkt pracy
FDpp=14; F1pp=109.0365; h2pp=15.6384*2; h1pp=h2pp*(alpha2/alpha1)^2;

% Parametry symulacji
tk=2000; Tp=50; kk=tk/Tp;
dF1in=10;

h0=[h1pp h2pp]; 
h_lin = h2pp;

[t,h]=skok_mod_lin([0 tk], h0, tk, F1pp, FDpp, h_lin, F1pp);

% Wyświetlenie wyników
figure;
% plot(Tp:Tp:tk, ys, '*');
% hold on;
plot(t, h);
legend('h1', 'h2');
xlabel('Czas (t)');
ylabel('Wysokoć');
title('Wykres odpowiedzi jednstkowej');
grid on; grid minor;