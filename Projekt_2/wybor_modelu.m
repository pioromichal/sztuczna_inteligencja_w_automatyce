% Główny skrypt do obliczenia błędu modelu neuronowego
clear all; close all; clc;

tryb = 'OE';

% Ścieżki do plików
modelFile = fullfile('modele', ...
    'model_K10_alg_BFGS_tryb_OE_proba_3.mat');    % Plik z parametrami modelu

% Wczytanie danych uczących i weryfikujących
load(fullfile('dane', 'dane_ucz.mat'), 'u_ucz', 'y_ucz');
load(fullfile('dane', 'dane_wer.mat'), 'u_wer', 'y_wer');

% Wczytanie parametrów modelu neuronowego
load(modelFile, 'w10', 'w1', 'w20', 'w2');

% Obliczenie błędu i wyjścia modelu
[E_ucz, y_mod_ucz] = oblicz_blad_modelu_neuron(u_ucz, y_ucz, w10, w1, w20, w2, tryb);
[E_wer, y_mod_wer] = oblicz_blad_modelu_neuron(u_wer, y_wer, w10, w1, w20, w2, tryb);

% Wyniki
% Wyświetlenie wyników
fprintf('Błąd dla danych uczących: %.5f\n', E_ucz);
fprintf('Błąd dla danych weryfikujących: %.5f\n', E_wer);

% Wizualizacja wyników
figure;
subplot(2,1,1); % Wykres dla danych uczących
plot(1:length(y_ucz), y_ucz, 'b', 'LineWidth', 1.5); hold on;
plot(1:length(y_mod_ucz), y_mod_ucz, 'r--', 'LineWidth', 1.5);
legend('Dane rzeczywiste - uczące', 'Wyjście modelu - uczące');
title('Porównanie danych rzeczywistych i wyjścia modelu (dane uczące)');
xlabel('Próbki');
ylabel('Wyjście');
grid on;

subplot(2,1,2); % Wykres dla danych weryfikujących
plot(1:length(y_wer), y_wer, 'b', 'LineWidth', 1.5); hold on;
plot(1:length(y_mod_wer), y_mod_wer, 'r--', 'LineWidth', 1.5);
legend('Dane rzeczywiste - weryfikujące', 'Wyjście modelu - weryfikujące');
title('Porównanie danych rzeczywistych i wyjścia modelu (dane weryfikujące)');
xlabel('Próbki');
ylabel('Wyjście');
grid on;


