clear all;

tk=2000;
Tp=50;
kk=tk/Tp;
F1in=80;
FD=14;

[h1_vals, h2_vals, t] = odp_skok_mod_lin(F1in, FD, kk, Tp);

d=(length(h2_vals)-1)/kk;

ys=h2_vals(d+1:d:length(h2_vals));

% ys=odp_jedn_fun(kk, Tp);


% Wyświetlenie wyników
figure;
% plot(t, h1_vals, '-', t, h2_vals, ':');
% hold on;
% plot(Tp:Tp:t(end), ys, '*');
plot(Tp:Tp:tk, ys, '*');
% legend('h1(t)', 'h2(t)', 'ys');
xlabel('Czas (t)');
ylabel('Wysokości (h1, h2)');
title('Rozwiązanie układu równań różniczkowych z opóźnieniem tau');
grid on;