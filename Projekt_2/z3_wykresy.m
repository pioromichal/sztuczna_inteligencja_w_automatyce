clear;

% Wczytanie danych uczących i weryfikujących
load dane\dane_ucz;
load dane\dane_wer;

% Wczytanie modelu
model = load('modele/model_rbf.mat', 'sn').sn;

% Generowanie i rysowanie wyników dla danych uczących
generuj_wykresy_rbf(model, 'ARX');

% Generowanie i rysowanie wyników dla danych weryfikujących
generuj_wykresy_rbf(model, 'OE');
