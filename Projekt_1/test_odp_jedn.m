clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=2000; Tp=50; kk=tk/Tp;
dF1in=10;

% Symulacja pozyskująca odpowiedź skokową
ys=odp_jedn_fun(kk, Tp, dF1in, F1pp, FDpp, h1pp, h2pp);


h0=[h1pp h2pp]; 
[t,h]=skok_mod_lin([0 tk], h0, tk, F1pp+dF1in, FDpp, F1pp, FDpp, h0);

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