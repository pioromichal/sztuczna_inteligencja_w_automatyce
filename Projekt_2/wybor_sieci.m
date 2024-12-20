function [w10_best, w1_best, w20_best, w2_best, E_ucz_best, E_wer_best] = wybor_sieci(W10, W1, W20, W2, tryb)
    % W10, W1, W20, W2 - tensory wag dla wszystkich prób
    % tryb - tryb uczenia ('ARX' lub 'OE')

    % Wczytanie danych uczących i weryfikujących
    dane_ucz = load(fullfile('dane', 'dane_ucz.mat'), 'u_ucz', 'y_ucz');
    u_ucz = dane_ucz.u_ucz;
    y_ucz = dane_ucz.y_ucz;

    dane_wer = load(fullfile('dane', 'dane_wer.mat'), 'u_wer', 'y_wer');
    u_wer = dane_wer.u_wer;
    y_wer = dane_wer.y_wer;

    liczba_prob = size(W1, 3); % Liczba prób (drugi wymiar tensorów)
    
    % Inicjalizacja zmiennych do przechowywania najlepszego modelu
    E_wer_best = inf; % Najmniejszy błąd weryfikacyjny (inicjalnie nieskończoność)
    w10_best = [];
    w1_best = [];
    w20_best = [];
    w2_best = [];
    E_ucz_best = NaN;

    % Iteracja przez wszystkie próby
    for i = 1:liczba_prob
        % Pobranie wag dla danej próby
        w10 = W10(:, :, i);
        w1 = W1(:, :, i);
        w20 = W20(:, :, i);
        w2 = W2(:, :, i);

        % Obliczenie błędów dla danych uczących i weryfikujących
        [E_ucz, ~] = oblicz_blad_modelu_neuron(u_ucz, y_ucz, w10, w1, w20, w2, tryb);
        [E_wer, ~] = oblicz_blad_modelu_neuron(u_wer, y_wer, w10, w1, w20, w2, tryb);

        % Sprawdzenie, czy ten model ma najmniejszy błąd weryfikacyjny
        if E_wer < E_wer_best
            % Aktualizacja najlepszych parametrów
            E_wer_best = E_wer;
            E_ucz_best = E_ucz;
            w10_best = w10;
            w1_best = w1;
            w20_best = w20;
            w2_best = w2;
        end
    end

    % Wyświetlenie informacji o najlepszym modelu
    fprintf('Najlepszy model wybrano na podstawie błędu weryfikacyjnego.\n');
    fprintf('Błąd uczący: %.5f\n', E_ucz_best);
    fprintf('Błąd weryfikacyjny: %.5f\n', E_wer_best);
end
