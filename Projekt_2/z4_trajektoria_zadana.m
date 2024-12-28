
% Macierz przechowująca pary [wartość_zadana, czas_trwania]
yzad_pairs = [
    0.1,  50;
   -1.0,  50;
   -2.5, 100;
    0.4, 100;
   -0.5,  50;
   -3.0, 100;
   -1.5,  50;
   -2.0,  50;
    0,    40;
];

yzad = zeros(1, 10);

for i = 1:size(yzad_pairs, 1)
    yzad = [yzad, yzad_pairs(i, 1) * ones(1, yzad_pairs(i, 2)*2)];
end


figure; hold on; grid on; grid minor;
stairs(yzad); 
xlabel('Czas [s]'); ylabel('y');
exportgraphics(gcf, 'Wykresy/z4_yzad.pdf', 'ContentType', 'vector');