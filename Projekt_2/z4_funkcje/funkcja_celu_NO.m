function J = funkcja_celu_NO(du, k, u, y, yzad, dk, w10, w1, w20, w2, N, Nu, lambda)
    Y = zeros(N,1);
    suma_bledow = 0;
    suma_kar_sterowania = 0;

    % Zakładając, że 'u' to wektor zmian sterowania (delta u), musimy zaktualizować zmienne wejściowe dla modelu
    for p = 1:N
        % Obliczanie odpowiedzi systemu w p-tej chwili
        if p-5 < 0
            ukm5 = u(k+p-5);
        elseif p-5+1<=Nu
            ukm5 = u(k-1)+sum(du(1:min(p-5+1,Nu)));
        else
            ukm5 = u(k-1)+sum(du(1:Nu));
        end
        if p-6 < 0
            ukm6 = u(k+p-6);
        elseif p-6+1<=Nu
            ukm6 = u(k-1)+sum(du(1:min(p-6+1,Nu)));
        else
            ukm6 = u(k-1)+sum(du(1:Nu));
        end
        if p-1<=0
            ykm1=y(k);
        else
            ykm1=Y(p-1);
        end
        if p-2<=0
            ykm2=y(k+p-2);
        else
            ykm2=Y(p-2);
        end
        
        % Obliczanie wyjścia modelu
        Y(p) = model_neuron(ukm5, ukm6, ykm1, ykm2, w10, w1, w20, w2)+dk;
        
        % Obliczanie błędów predykcji
        suma_bledow = suma_bledow + (yzad - Y(p))^2;
    end
    
    % Kara za zmiany sterowania (delta u)
    for p = 1:Nu
        suma_kar_sterowania = suma_kar_sterowania + du(p)^2;
    end
    
    % Całkowity koszt
    J = suma_bledow + lambda * suma_kar_sterowania;
end