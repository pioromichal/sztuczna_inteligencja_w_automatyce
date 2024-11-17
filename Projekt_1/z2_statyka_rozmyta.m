clear all;

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=10000000;
tspan=[0 tk];
h0=[h1pp h2pp];

h2_lin_rozm=[5; h2pp; 50];

hs = [];
hsr = [];

for F1in= 0:1:200
    % Parametry skoku
    FD=FDpp;

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm, 5);

    hs = [hs, h_nlin(end,2)];
    hsr = [hsr, h_rozm2(end,2)];

end

% Wyświetlenie wyników
figure;
plot(0:1:200, hs, 0:1:200, hsr);
xlabel('F_{1in}');
ylabel('Wysokość h_2');
% title('');
grid on; grid minor;

% Generowanie nazwy pliku
file_name = sprintf('wykresy/Zad1/statyka.pdf');

% Export wykresu do pliku .pdf
exportgraphics(gcf, file_name, 'ContentType', 'vector');
% close;