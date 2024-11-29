clear all;
C1 = 0.35; C2 = 0.3; alpha1 = 20; alpha2 = 22; tau = 150;

% Punkt pracy
FDpp=14;  h2pp=15.6384; h1pp=h2pp*(alpha2/alpha1)^2;
F1pp = 73;

% Parametry symulacji
tk=5000; Tp=10; kk=tk/Tp;
dF1in=10;

h0=[h1pp h2pp]; 
h_lin = h2pp;
punkty_rozmycia = h2pp*[0.5; 0.75; 1; 1.25; 1.5];

% Utworzenie wykresu
figure;
hold on;

% Iteracja po punktach rozmycia
for i = 1:length(punkty_rozmycia)
    h2 = punkty_rozmycia(i);
    h0 = [h1pp h2];
    
    % Symulacja odpowiedzi skokowej
    F1pp = znajdz_F1pp(h2);
    ys = odp_jedn_fun(kk, Tp, dF1in, h2, F1pp);
    
    % Wyświetlenie wyników
    plot(Tp:Tp:tk, ys, '.', 'MarkerSize', 5);
    legend_entries{i} = sprintf('Model %d', i); % Dodanie etykiety do legendy
end

legend(legend_entries, 'Location', 'southeast');


legend('Location', 'best');
xlabel('Czas (t)');
ylabel('Wysokość');
title('Wykres odpowiedzi jednostkowej dla poszczególnych punktów rozmycia');
grid on;
grid minor;

% Zapis wykresu do pliku PDF
file_name = sprintf('wykresy/Zad2/odpowiedzi_jednostkowe_rozmycie.pdf');
exportgraphics(gcf, file_name, 'ContentType', 'vector');
