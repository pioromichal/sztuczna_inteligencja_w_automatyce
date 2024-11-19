clear all;
C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

% Punkt pracy
FDpp=14;  h2pp=15.6384*0.5; h1pp=h2pp*(alpha2/alpha1)^2;
F1pp=znajdz_F1pp(h2pp);
% Parametry symulacji
tk=1000; Tp=10; kk=tk/Tp;
dF1in=10;

h0=[h1pp h2pp]; 
h_lin = h2pp;

% Symulacja pozyskująca odpowiedź skokową
ys=odp_jedn_fun(kk, Tp, dF1in, h_lin, F1pp);


[t,h]=skok_mod_lin([0 tk], h0, tk, F1pp+dF1in, FDpp, h_lin, F1pp);

y=(h(:,2)-h2pp)/dF1in;
% Wyświetlenie wyników
figure;
plot(Tp:Tp:tk, ys, '*');
hold on;
plot(t, y);
legend('ys', 'y');
xlabel('Czas (t)');
ylabel('Wysokoć');
title('Wykres odpowiedzi jednstkowej');
grid on; grid minor;