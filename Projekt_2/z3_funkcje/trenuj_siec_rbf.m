function [sn]=trenuj_siec_rbf(u_ucz, y_ucz, edopuszcz, max_neurony)
    % Przygotowanie danych uczących
    tau = 5;
    [U_ucz, Y_ucz] = przygotuj_dane(u_ucz, y_ucz, tau);

    % Trenowanie modelu
    disp(['Trenowanie modelu z błędem dopuszczalnym = ', num2str(edopuszcz), ...
        ' i maksymalną liczbą neuronów ukrytych = ', num2str(max_neurony)]);
    sn = newrb(U_ucz', Y_ucz', edopuszcz, 1, max_neurony, 1);
    finalna_liczba_neuronow = size(sn.IW{1}, 1);

    nazwa_pliku = sprintf('model_rbf_err_%.7f_n_%d.mat', ...
        edopuszcz, finalna_liczba_neuronow);    sciezka = fullfile('modele', 'rbf', nazwa_pliku);
    save(sciezka, 'sn');
    disp(['Model został zapisany w pliku: ', sciezka]);
end

function [U, Y] = przygotuj_dane(u, y, tau)
    % Przygotowanie danych wejściowych i wyjściowych z uwzględnieniem opóźnienia tau
    Y = y(tau + 2:end);
    U = [];
    for k = tau+2:length(y)
        U = [U; u(k-tau), u(k-tau-1), y(k-1), y(k-2)];
    end
end
