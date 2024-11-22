clear all;
addpath("funkcje_przynaleznosci")

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

% Parametry symulacji
tk=10000;
tspan=[0 tk];
h0=[h1pp h2pp];

% h2_lin_rozm=[7.819200000000000;23.457599999999999]
h2_lin_rozm=h2pp*[0.5;2];

mi=[];
for z=0:0.1:25
    mi=[mi;fun_przyn_trap(z,h2_lin_rozm, 10)];
end
figure;
plot(0:0.1:25, mi());

hs = [];
hsr = [];

F1in_vals= 80:0.25:110;

for F1in=F1in_vals
    % Parametry skoku
    FD=FDpp;

    % Symulacja modeli obiektu dla skoku sterowania
    [t_nlin, h_nlin] = skok_mod_nlin(tspan, h0, tk, F1in, FD);
    [t_rozm2, h_rozm2] = skok_mod_rozm(tspan, h0, tk, F1in, FD, h2_lin_rozm, 10);
    hs = [hs, h_nlin(end,2)];
    hsr = [hsr, h_rozm2(end,2)];

end

% Wyświetlenie wyników
figure;
plot(F1in_vals, hs, F1in_vals, hsr, '*');
xlabel('F_{1in}');
ylabel('Wysokość h_2');
% title('');
grid on; grid minor;

% Generowanie nazwy pliku
file_name = sprintf('wykresy/Zad2/statyka_rozmyta.pdf');

% Export wykresu do pliku .pdf
exportgraphics(gcf, file_name, 'ContentType', 'vector');
% close;