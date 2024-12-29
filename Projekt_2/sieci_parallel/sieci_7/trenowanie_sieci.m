clear all;

% Definicja parametrów
tau = 5;                     % τ
nB = 6;                      % nB
nA = 2;                      % nA
K = 10;                      % liczba neuronów ukrytych (max 50)
maxIter = 50;                % maksymalna liczba iteracji uczących
errorThreshold = 0.00001;    % błąd graniczny
learningAlgorithm = 2;       % algorytm uczący: 1 - najszybszy spadek, 2 - BFGS
learningMode = 2;            % tryb uczenia: 1 - ARX, 2 - OE
trys_num = 3;                % Liczba prób trenowania sieci

% Definicje nazw dla algorytmu i trybu uczenia
if learningAlgorithm == 1
    learningAlgorithmName = 'najszybszy_spadek';
elseif learningAlgorithm == 2
    learningAlgorithmName = 'BFGS';
else
    error('Nieznany algorytm');
end

if learningMode == 1
    learningModeName = 'ARX';
elseif learningMode == 2
    learningModeName = 'OE';
else
    error('Nieznany tryb uczenia');
end

% Ścieżki do plików
settingsFilePath = fullfile(pwd, 'ustawienia.txt');
exePath = fullfile(pwd, 'sieci.exe');
outputFolder = fullfile(pwd, 'modele');

% Tworzenie folderu na modele, jeśli nie istnieje
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Pętla dla każdej próby trenowania
for i = 1:trys_num
    fprintf('Próba trenowania %d z %d\n', i, trys_num);
    
    % Zapis parametrów do pliku ustawienia.txt
    fileID = fopen(settingsFilePath, 'w'); 
    if fileID == -1
        error('Nie można otworzyć pliku ustawienia.txt');
    end
    fprintf(fileID, '%d %d %d %d %d %.5f %d %d\n', ...
            tau, nB, nA, K, maxIter, errorThreshold, learningAlgorithm, learningMode);
    fclose(fileID);
    disp('Parametry zostały zapisane do pliku ustawienia.txt.');

    % Uruchomienie pliku sieci.exe
    [~, result] = system(['"' exePath '"']);
    % disp('Wynik działania sieci.exe:');
    % disp(result);

    % Wczytanie danych z pliku model.m
    run('model.m');

    % Generowanie nazwy pliku na podstawie parametrów sieci i numeru próby
    fileName = sprintf('model_K%d_alg_%s_tryb_%s_proba_%d.mat', ...
                        K, learningAlgorithmName, learningModeName, i);
    outputFilePath = fullfile(outputFolder, fileName);

    % Zapisanie wag oraz parametrów bezpośrednio do pliku .mat
    save(outputFilePath, 'w10', 'w1', 'w20', 'w2', 'tau', 'nB', 'nA', 'K', '');

    disp(['Model z próby ', num2str(i), ' został zapisany do pliku: ', outputFilePath]);
end

disp('Trenowanie zakończone.');
