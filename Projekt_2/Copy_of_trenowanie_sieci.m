function trenowanie_sieci(K, alg_uczacy, tryb_uczenia, liczba_prob)
    % Definicja stałych parametrów
    opoznienie = 5;              % τ
    nB = 6;                      % nB
    nA = 2;                      % nA
    max_iteracji = 50;           % maksymalna liczba iteracji uczących
    prog_bledu = 0.00001;        % błąd graniczny

    % Definicje nazw dla algorytmu i trybu uczenia
    if alg_uczacy == 1
        nazwa_alg_uczacego = 'najszybszy_spadek';
    elseif alg_uczacy == 2
        nazwa_alg_uczacego = 'BFGS';
    end

    if tryb_uczenia == 1
        nazwa_trybu_uczenia = 'ARX';
    elseif tryb_uczenia == 2
        nazwa_trybu_uczenia = 'OE';
    end

    % Ścieżki do plików
    folder_sieci = fullfile(pwd, 'sieci'); % Folder z plikiem sieci.exe
    sciezka_ustawienia = fullfile(folder_sieci, 'ustawienia.txt');
    sciezka_exe = fullfile(folder_sieci, 'sieci.exe');
    folder_modele = fullfile(pwd, 'modele');

    % Tworzenie folderu na modele, jeśli nie istnieje
    if ~exist(folder_modele, 'dir')
        mkdir(folder_modele);
    end

    % Zapis bieżącego katalogu
    biezacy_folder = pwd;

    % Pętla dla każdej próby trenowania
    for i = 1:liczba_prob
        fprintf('Próba trenowania %d z %d\n', i, liczba_prob);
        
        % Przejście do folderu sieci
        cd(folder_sieci);

        % Zapis parametrów do pliku ustawienia.txt
        fileID = fopen(sciezka_ustawienia, 'w'); 
        fprintf(fileID, '%d %d %d %d %d %.5f %d %d\n', ...
                opoznienie, nB, nA, K, max_iteracji, prog_bledu, alg_uczacy, tryb_uczenia);
        fclose(fileID);
        disp('Parametry zostały zapisane do pliku ustawienia.txt.');

        % Uruchomienie pliku sieci.exe
        system(['"' sciezka_exe '"']);

        % Wczytanie danych z pliku model.m
        run('model.m');

        % Powrót do pierwotnego katalogu
        cd(biezacy_folder);

        % Generowanie nazwy pliku na podstawie parametrów sieci i numeru próby
        nazwa_pliku = sprintf('model_K%d_alg_%s_tryb_%s_proba_%d.mat', ...
                              K, nazwa_alg_uczacego, nazwa_trybu_uczenia, i);
        sciezka_modelu = fullfile(folder_modele, nazwa_pliku);

        % Zapisanie wag oraz parametrów bezpośrednio do pliku .mat
        save(sciezka_modelu, 'w10', 'w1', 'w20', 'w2', 'opoznienie', 'nB', 'nA', 'K');

        disp(['Model z próby ', num2str(i), ' został zapisany do pliku: ', sciezka_modelu]);
    end

    disp('Trenowanie zakończone.');
end
