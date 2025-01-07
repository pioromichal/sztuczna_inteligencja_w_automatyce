% Przygotowanie danych uczących i weryfikacyjnych
dane_ucz = load('dane/dane_ucz.mat', 'u_ucz', 'y_ucz');
u_ucz = dane_ucz.u_ucz;
y_ucz = dane_ucz.y_ucz;

dane_wer = load('dane/dane_wer.mat', 'u_wer', 'y_wer');
u_wer = dane_wer.u_wer;
y_wer = dane_wer.y_wer;

% Wektory błędów dopuszczalnych i liczby neuronów
edopuszcz_wekt = [0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001];
max_neurony_wekt = [3, 6, 15, 29, 56, 77, 100];
% edopuszcz_wekt = [0.1, 0.01];
% max_neurony_wekt = [3, 6];
% Obliczenie błędów dla różnych modeli
oblicz_bledy_modeli_rbf(edopuszcz_wekt, max_neurony_wekt, u_ucz, y_ucz, u_wer, y_wer);
