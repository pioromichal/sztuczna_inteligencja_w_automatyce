function generuj_wykresy_por_sieci(w10, w1, w20, w2, tryb)
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

    % Generowanie wykresów porównujących dane rzeczywiste i wyjścia modelu
    figure;
    
    % Wykres dla danych uczących
    subplot(2,1,1); 
    plot(1:length(y_ucz), y_ucz); hold on;
    plot(1:length(y_mod_ucz), y_mod_ucz);
    legend('Obiekt', 'Model');
    title('Dane uczące E%f',E_ucz);
    xlabel('Próbki');
    ylabel('Wyjście');
    grid on;

    % Wykres dla danych weryfikujących
    subplot(2,1,2);
    plot(1:length(y_wer), y_wer); hold on;
    plot(1:length(y_mod_wer), y_mod_wer);
    legend('Obiekt', 'Model');
    title('Dane weryfikujące E%f',E_wer);
    xlabel('Próbki');
    ylabel('Wyjście');
    grid on;
end
