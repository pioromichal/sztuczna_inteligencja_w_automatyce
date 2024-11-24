clear all;
C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

% Punkt pracy
FDpp=14;  h2pp=15.6384; h1pp=h2pp*(alpha2/alpha1)^2;
F1pp = 73;
% Parametry symulacji
tk=2000; Tp=10; kk=tk/Tp;
dF1in=10;

h0=[h1pp h2pp]; 
h_lin = h2pp;

% Symulacja pozyskująca odpowiedź skokową
ys=odp_jedn_fun(kk, Tp, dF1in, h_lin, F1pp);
[t,h]=skok_mod_lin([0 tk], h0, tk, F1pp+dF1in, FDpp, h_lin, F1pp);


y=(h(:,2)-h2pp)/dF1in;
% Wyświetlenie wyników
figure;
hold on;
plot(t, y);
plot(Tp:Tp:tk, ys, '.', 'MarkerSize', 5);
legend('y', 'ys', 'Location','southwest');
xlabel('Czas (t)');
ylabel('Wysokoć');
title('Wykres odpowiedzi jednstkowej');
grid on; grid minor;
file_name = sprintf('wykresy/Zad1/odpowiedz_jednostkowa.pdf');

% Export wykresu do pliku .pdf
exportgraphics(gcf, file_name, 'ContentType', 'vector');
% close all;