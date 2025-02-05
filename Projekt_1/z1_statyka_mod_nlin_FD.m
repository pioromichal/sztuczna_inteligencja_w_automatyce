clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=10000000;
tspan=[0 tk];
h0=[h1pp h2pp];

hs = [];

FD_vals= 5:0.25:25;

for FD = FD_vals
    % Parametry skoku
    F1in=F1pp;

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);

    hs = [hs, h_nlin(end,2)];

end

% Wyświetlenie wyników
figure;
plot(FD_vals, hs);
xlabel('F_{D}');
ylabel('Wysokość h_2');
% title('');
grid on; grid minor;

% Generowanie nazwy pliku
file_name = sprintf('wykresy/Zad1/statyka_FD.pdf');

% Export wykresu do pliku .pdf
exportgraphics(gcf, file_name, 'ContentType', 'vector');
% close;