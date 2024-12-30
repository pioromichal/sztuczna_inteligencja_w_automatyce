function generuj_wykresy_rbf(model, tryb)
    % Wczytanie danych uczących
    dane_ucz = load(fullfile('dane', 'dane_ucz.mat'), 'u_ucz', 'y_ucz');
    u_ucz = dane_ucz.u_ucz;
    y_ucz = dane_ucz.y_ucz;

    % Wczytanie danych weryfikujących
    dane_wer = load(fullfile('dane', 'dane_wer.mat'), 'u_wer', 'y_wer');
    u_wer = dane_wer.u_wer;
    y_wer = dane_wer.y_wer;

    % Obliczenie wyjść modelu i błędów dla danych uczących
    [y_mod_ucz, E_ucz] = oblicz_blad_modelu_rbf(u_ucz, y_ucz, model, tryb);

    % Obliczenie wyjść modelu i błędów dla danych weryfikujących
    [y_mod_wer, E_wer] = oblicz_blad_modelu_rbf(u_wer, y_wer, model, tryb);

    % Upewnij się, że folder na wykresy istnieje
    folder_wykresy = fullfile('Wykresy', 'zadanie_3');
    if ~exist(folder_wykresy, 'dir')
        mkdir(folder_wykresy);
    end

    % Generowanie i zapisywanie wykresów dla danych uczących
    figure;
    plot(1:length(y_ucz), y_ucz); hold on;
    plot(1:length(y_mod_ucz), y_mod_ucz, '--');
    legend('Obiekt', 'Model', 'Location', 'southeast');
    title(sprintf('Dane uczące (E = %.5f)', E_ucz));
    xlabel('k');
    ylabel('y');
    grid on; grid minor;
    nazwa_pliku = fullfile(folder_wykresy, sprintf('z3_dane_ucz_czasowe_tryb_%s.pdf', tryb));
    zamien_kropki();
    exportgraphics(gcf, nazwa_pliku, 'ContentType', 'vector');

    figure;
    plot(y_ucz, y_mod_ucz, '.');
    title(sprintf('Porównanie danych uczących (E = %.5f)', E_ucz));
    xlabel('y_{obiekt}');
    ylabel('y_{model}');
    grid on; grid minor;
    nazwa_pliku = fullfile(folder_wykresy, sprintf('z3_dane_ucz_porownanie_tryb_%s.pdf', tryb));
    zamien_kropki();
    exportgraphics(gcf, nazwa_pliku, 'ContentType', 'vector');

    % Generowanie i zapisywanie wykresów dla danych weryfikujących
    figure;
    plot(1:length(y_wer), y_wer); hold on;
    plot(1:length(y_mod_wer), y_mod_wer, '--');
    legend('Obiekt', 'Model', 'Location', 'southeast');
    title(sprintf('Dane weryfikujące (E = %.5f)', E_wer));
    xlabel('k');
    ylabel('y');
    grid on; grid minor;
    nazwa_pliku = fullfile(folder_wykresy, sprintf('z3_rbf_dane_wer_czasowe_tryb_%s.pdf', tryb));
    zamien_kropki();
    exportgraphics(gcf, nazwa_pliku, 'ContentType', 'vector');

    figure;
    plot(y_wer, y_mod_wer, '.');
    title(sprintf('Porównanie danych weryfikujących (E = %.5f)', E_wer));
    xlabel('y_{obiekt}');
    ylabel('y_{model}');
    grid on;
    nazwa_pliku = fullfile(folder_wykresy, sprintf('z3_rbf_dane_wer_porownanie_tryb_%s.pdf', tryb));
    zamien_kropki();
    exportgraphics(gcf, nazwa_pliku, 'ContentType', 'vector');

    % Informacja o wynikach
    fprintf('Tryb: %s\n', tryb);
    fprintf('Dane uczące: Błąd kwadratowy = %.5f\n', E_ucz);
    fprintf('Dane weryfikujące: Błąd kwadratowy = %.5f\n', E_wer);
end
