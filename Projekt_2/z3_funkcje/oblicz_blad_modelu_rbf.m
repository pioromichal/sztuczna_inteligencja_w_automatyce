function [y_mod, E] = oblicz_blad_modelu_rbf(u, y, model, tryb)
    N = length(y);
    y_mod = zeros(N, 1); % Inicjalizacja wektora wyjść modelu
    tau=5;
    % Start iteracji
    for k = tau + 2:N
        if strcmp(tryb, 'ARX')
            ykm1 = y(k-1);
            ykm2 = y(k-2);
        elseif strcmp(tryb, 'OE')
            ykm1 = y_mod(k-1);
            ykm2 = y_mod(k-2);
        end
        ukm6 = u(k-tau);
        ukm5 = u(k-tau-1);

        % Obliczanie wyjścia modelu
        y_mod(k) = model_rbf(model, ukm5, ukm6, ykm1, ykm2);
    end

    % Obliczanie błędu kwadratowego
    E = sum((y(tau+2:end) - y_mod(tau+2:end)).^2);
end
