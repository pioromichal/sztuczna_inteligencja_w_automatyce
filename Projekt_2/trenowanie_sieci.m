function [W10, W1, W20, W2] = trenowanie_sieci(K, alg_uczacy, tryb_uczenia, liczba_prob)
    % Definicja stałych parametrów
    tau = 5;                     % τ
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

    % Przygotowanie tensorów na parametry
    % Zakładamy, że rozmiary parametrów wag są znane i stałe
    rozmiar_w10 = [K, 1];
    rozmiar_w1 = [K, nB-tau+1+nA];
    rozmiar_w20 = [1, 1];
    rozmiar_w2 = [1, K];
    W10 = zeros([rozmiar_w10, liczba_prob]);
    W1 = zeros([rozmiar_w1, liczba_prob]);
    W20 = zeros([rozmiar_w20, liczba_prob]);
    W2 = zeros([rozmiar_w2, liczba_prob]);

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
                tau, nB, nA, K, max_iteracji, prog_bledu, alg_uczacy, tryb_uczenia);
        fclose(fileID);
        disp('Parametry zostały zapisane do pliku ustawienia.txt.');

        % Uruchomienie pliku sieci.exe
        system(['"' sciezka_exe '"']);

        % Wczytanie danych z pliku model.m
        run('model.m');

        % Zapisanie parametrów do tensorów
        W10(:, :, i) = w10;
        W1(:, :, i) = w1;
        W20(:, :, i) = w20;
        W2(:, :, i) = w2;

        disp(['Parametry z próby ', num2str(i), ' zostały zapisane do tensorów.']);
    end
    % Powrót do pierwotnego katalogu
    cd(biezacy_folder);
    disp('Trenowanie zakończone.');
end
