function oblicz_bledy_modeli_rbf(edopuszcz_wekt, neurony_wekt, u_ucz, y_ucz, u_wer, y_wer)
    % Przygotowanie wektorów na błędy
    E_ucz_OE = zeros(length(edopuszcz_wekt), 1);  % Błędy w trybie OE dla danych uczących
    E_ucz_ARX = zeros(length(edopuszcz_wekt), 1);  % Błędy w trybie ARX dla danych uczących
    E_wer_OE = zeros(length(edopuszcz_wekt), 1);  % Błędy w trybie OE dla danych weryfikacyjnych
    E_wer_ARX = zeros(length(edopuszcz_wekt), 1);  % Błędy w trybie ARX dla danych weryfikacyjnych
    
    % Iteracja przez różne wartości błędów dopuszczalnych i liczby neuronów
    for i = 1:length(edopuszcz_wekt)
        % Tworzenie ścieżki do pliku modelu
        nazwa_pliku = sprintf('model_rbf_err_%.7f_n_%d.mat', edopuszcz_wekt(i), neurony_wekt(i));
        sciezka_pliku = fullfile('modele', 'rbf', nazwa_pliku);
        
        % Sprawdzanie, czy plik z modelem istnieje
        % Wczytanie modelu z pliku
        model = load(sciezka_pliku, 'sn');
        model = model.sn;  % Zmienna modelu

        % Obliczanie błędów dla danych uczących i weryfikacyjnych w trybie 'OE' i 'ARX'
        [~,E_ucz_OE(i,1)] = oblicz_blad_modelu_rbf(u_ucz, y_ucz, model, 'OE');
        [~,E_ucz_ARX(i,1)] = oblicz_blad_modelu_rbf(u_ucz, y_ucz, model, 'ARX');
        [~,E_wer_OE(i,1)] = oblicz_blad_modelu_rbf(u_wer, y_wer, model, 'OE');
        [~,E_wer_ARX(i,1)] = oblicz_blad_modelu_rbf(u_wer, y_wer, model, 'ARX');

    end

    % Wyświetlanie wyników
    fprintf('E_ucz i E_wer w trybie OE i ARX:\n');
    for i = 1:length(edopuszcz_wekt)
        fprintf('edopuszcz = %.5f, neurony = %d: E_ucz (OE) = %.5f, E_ucz (ARX) = %.5f, E_wer (OE) = %.5f, E_wer (ARX) = %.5f\n', ...
            edopuszcz_wekt(i), neurony_wekt(i), E_ucz_OE(i), E_ucz_ARX(i), E_wer_OE(i), E_wer_ARX(i));
    end
end
