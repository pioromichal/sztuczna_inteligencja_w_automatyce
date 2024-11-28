clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=10000000;
tspan=[0 tk];
h0=[h1pp h2pp];

h2_lin=h2pp;

hs = [];
hsl = [];

F1in_vals= 30:0.25:110;

for F1in=F1in_vals
    % Parametry skoku
    FD=FDpp;

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [t_lin, h_lin] = skok_mod_lin(tspan, h0, tk, F1in, FD, h2_lin);
    disp (F1in)
    hs = [hs, h_nlin(end,2)];
    hsl = [hsl, h_lin(end,2)];

end

% Wyświetlenie wyników
figure;
plot(F1in_vals, hs, F1in_vals, hsl);
xlabel('F_{1in}');
ylabel('Wysokość h_2');
legend('Model nieliniowy', 'Model zlinearyzowany', 'Location','northwest')
% title('');
grid on; grid minor;

% Generowanie nazwy pliku
file_name = sprintf('wykresy/Zad1/statyka_lin_porownanie.pdf');

% Export wykresu do pliku .pdf
exportgraphics(gcf, file_name, 'ContentType', 'vector');
% close;