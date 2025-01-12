clear;

% Wczytanie danych uczących i weryfikujących
load(fullfile('dane', 'dane_ucz.mat'));
load(fullfile('dane', 'dane_wer.mat'));

% Wczytanie modelu
model_path = fullfile('modele', 'rbf','model_rbf_err_0.0001000_n_29.mat');
model = load(model_path, 'sn').sn;

% Generowanie i rysowanie wyników dla danych uczących
generuj_wykresy_rbf(model, 'ARX');

% Generowanie i rysowanie wyników dla danych weryfikujących
generuj_wykresy_rbf(model, 'OE');
