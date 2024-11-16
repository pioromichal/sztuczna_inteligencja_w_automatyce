clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry skoku
FD=FDpp;
F1in=F1pp*0.7;

% Parametry symulacji
tk=2000;
tspan=[0 tk];
h0=[h1pp h2pp];
h2_lin = h2pp;
h2_lin_rozm=[10; h2pp; 20];

% % Symulacja skoku sterowania
[t, h] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
% F1pp=[F1pp-50 F1pp F1pp+50];
% FDpp=[FDpp FDpp FDpp];
[trozm, hrozm] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm,2);




% Wyświetlenie wyników
figure;
h1_vals=h(:,1);
h2_vals=h(:,2);
plot(t, h1_vals, '-', t, h2_vals, '-');
hold on;
h1_vals=hrozm(:,1);
h2_vals=hrozm(:,2);
plot(trozm, h1_vals, '-.', trozm, h2_vals, '-.');
legend('h1(t)', 'h2(t)', 'h1r', 'h2r');
xlabel('Czas (t)');
ylabel('Wysokości (h1, h2)');
title(['Symulacja modelu nieliniowego po skoku sterowania F_{1in}=', num2str(F1in)]);
grid on;