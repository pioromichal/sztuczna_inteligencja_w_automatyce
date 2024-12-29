function [E_ucz, E_wer] = oblicz_bledy_modeli_neuron(alg_uczacy, tryb_uczenia, liczba_prob)


    % Stały folder, w którym znajdują się zapisane modele
    folder_modele = 'modele/sieci';

    % Zamiana alg_uczacy na tekst
    switch alg_uczacy
        case 1
            algorytm = 'najszybszy_spadek';
        case 2
            algorytm = 'BFGS';
        otherwise
            error('Nieznany algorytm uczący: %d', alg_uczacy);
    end

    % Zamiana tryb_uczenia na tekst
    switch tryb_uczenia
        case 1
            tryb = 'ARX';
        case 2
            tryb = 'OE';
        otherwise
            error('Nieznany tryb uczenia: %d', tryb_uczenia);
    end

    % Wczytanie danych uczących i weryfikacyjnych
    dane_ucz = load(fullfile('dane', 'dane_ucz.mat'), 'u_ucz', 'y_ucz');
    u_ucz = dane_ucz.u_ucz;
    y_ucz = dane_ucz.y_ucz;

    dane_wer = load(fullfile('dane', 'dane_wer.mat'), 'u_wer', 'y_wer');
    u_wer = dane_wer.u_wer;
    y_wer = dane_wer.y_wer;

    % Inicjalizacja wektorów na błędy
    E_ucz = zeros(1, liczba_prob);
    E_wer = zeros(1, liczba_prob);

    % Iteracja przez wszystkie modele
    for K = 1:liczba_prob
        % Tworzenie nazwy pliku
        nazwa_pliku = fullfile(folder_modele, sprintf('model_K%d_alg_%s_tryb_%s.mat', K, algorytm, tryb));
        
        % Wczytanie modelu
        if isfile(nazwa_pliku)
            model = load(nazwa_pliku, 'w10', 'w1', 'w20', 'w2');
            w10 = model.w10;
            w1 = model.w1;
            w20 = model.w20;
            w2 = model.w2;
            
            % Obliczenie błędów
            [E_ucz(K), ~] = oblicz_blad_modelu_neuron(u_ucz, y_ucz, w10, w1, w20, w2, tryb);
            [E_wer(K), ~] = oblicz_blad_modelu_neuron(u_wer, y_wer, w10, w1, w20, w2, tryb);
        else
            % Ustawienie NaN, jeśli plik nie istnieje
            E_ucz(K) = NaN;
            E_wer(K) = NaN;
        end
    end

    % Wyświetlenie wyników
    fprintf('K\tBłąd uczący\tBłąd weryfikacyjny\n');
    for K = 1:liczba_prob
        fprintf('%d\t%.5f\t\t%.5f\n', K, E_ucz(K), E_wer(K));
    end
end
