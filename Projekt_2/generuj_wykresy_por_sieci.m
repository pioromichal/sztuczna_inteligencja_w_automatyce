function generuj_wykresy_por_sieci(w10, w1, w20, w2, tryb, K, alg_ucz, tryb_ucz)
    if alg_ucz == 1
        algorytm_str = 'najszybszy_spadek';
    elseif alg_ucz == 2
        algorytm_str = 'BFGS';
    end

    if tryb_ucz == 1
        tryb_ucz_str = 'ARX';
    elseif tryb_ucz == 2
        tryb_ucz_str = 'OE';
    end

    if tryb == 1
        tryb_str = 'ARX';
    elseif tryb == 2
        tryb_str = 'OE';
    end

    % Wczytanie danych uczących i weryfikujących
    dane_ucz = load(fullfile('dane', 'dane_ucz.mat'), 'u_ucz', 'y_ucz');
    u_ucz = dane_ucz.u_ucz;
    y_ucz = dane_ucz.y_ucz;

    dane_wer = load(fullfile('dane', 'dane_wer.mat'), 'u_wer', 'y_wer');
    u_wer = dane_wer.u_wer;
    y_wer = dane_wer.y_wer;

    % Obliczenie wyjść modelu dla danych uczących i weryfikujących
    [E_ucz, y_mod_ucz] = oblicz_blad_modelu_neuron(u_ucz, y_ucz, w10, w1, w20, w2, tryb);
    [E_wer, y_mod_wer] = oblicz_blad_modelu_neuron(u_wer, y_wer, w10, w1, w20, w2, tryb);

    % Wyświetlenie wyników
    fprintf('Błąd uczący: %.5f\n', E_ucz);
    fprintf('Błąd weryfikacyjny: %.5f\n', E_wer);

    % Wykres dla danych uczących: Obiekt vs Model
    figure;
    plot(1:length(y_ucz), y_ucz); hold on;
    plot(1:length(y_mod_ucz), y_mod_ucz, '--');
    legend('Obiekt', 'Model');
    title(sprintf('Dane uczące (E_{ucz} = %.5f)', E_ucz));
    xlabel('Próbki');
    ylabel('Wyjście');
    grid on; grid minor;
    nazwa_pliku = sprintf('sieci_dane_ucz_w_czasie_tryb_sym_%s_K%d_alg_%s_tryb_u_%s.pdf', tryb_str, K, algorytm_str, tryb_ucz_str);
    sciezka_pliku = fullfile('Wykresy','sieci',nazwa_pliku);
    exportgraphics(gcf, sciezka_pliku , 'ContentType', 'vector');

    % Wykres dla danych weryfikujących: Obiekt vs Model
    figure;
    plot(1:length(y_wer), y_wer); hold on;
    plot(1:length(y_mod_wer), y_mod_wer, '--');
    legend('Obiekt', 'Model');
    title(sprintf('Dane weryfikujące (E_{wer} = %.5f)', E_wer));
    xlabel('Próbki');
    ylabel('Wyjście');
    grid on; grid minor;
    nazwa_pliku = sprintf('sieci_dane_wer_w_czasie_tryb_sym_%s_K%d_alg_%s_tryb_u_%s.pdf', tryb_str, K, algorytm_str, tryb_ucz_str);
    sciezka_pliku = fullfile('Wykresy','sieci',nazwa_pliku);
    exportgraphics(gcf, sciezka_pliku , 'ContentType', 'vector');


    figure;
    plot(y_ucz, y_mod_ucz,'.'); hold on;
    title(sprintf(' (E_{ucz} = %.5f)', E_ucz));
    xlabel('y_{ucz}');
    ylabel('y_{mod}');
    grid on; grid minor;
    nazwa_pliku = sprintf('sieci_dane_ucz_tryb_sym_%s_K%d_alg_%s_tryb_u_%s.pdf', tryb_str, K, algorytm_str, tryb_ucz_str);
    sciezka_pliku = fullfile('Wykresy','sieci',nazwa_pliku);
    exportgraphics(gcf, sciezka_pliku , 'ContentType', 'vector');

    figure;
    plot(y_wer, y_mod_wer,'.'); hold on;
    title(sprintf(' (E_{wer} = %.5f)', E_wer));
    xlabel('y_{wer}');
    ylabel('y_{mod}');
    grid on; grid minor;
    nazwa_pliku = sprintf('sieci_dane_wer_tryb_sym_%s_K%d_alg_%s_tryb_u_%s.pdf', tryb_str, K, algorytm_str, tryb_ucz_str);
    sciezka_pliku = fullfile('Wykresy','sieci',nazwa_pliku);
    exportgraphics(gcf, sciezka_pliku , 'ContentType', 'vector');
end
