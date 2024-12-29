function zapisz_model_neuron_do_pliku(w10, w1, w20, w2, K, algorytm, tryb_uczenia, farx, foe)
    % w10, w1, w20, w2 - wagi modelu
    % K, tryb_uczenia, algorytm - parametry modelu, na podstawie których będzie tworzona nazwa pliku
    
    % Tworzenie nazwy pliku na podstawie parametrów
    if algorytm == 1
        algorytm_str = 'najszybszy_spadek';
    elseif algorytm == 2
        algorytm_str = 'BFGS';
    else
        algorytm_str = 'nieznany_algorytm';
    end
    
    if tryb_uczenia == 1
        tryb_str = 'ARX';
    elseif tryb_uczenia == 2
        tryb_str = 'OE';
    else
        tryb_str = 'nieznany_tryb';
    end
    
    % Tworzenie pełnej nazwy pliku
    nazwa_pliku = fullfile('modele','sieci', sprintf('model_K%d_alg_%s_tryb_%s.mat', K, algorytm_str, tryb_str));
    
    % Zapisanie wag do pliku .mat
    save(nazwa_pliku, 'w10', 'w1', 'w20', 'w2', 'farx', 'foe');
    
    % Informacja o zapisaniu modelu
    fprintf('Model zapisano do pliku: %s\n', nazwa_pliku);
end
