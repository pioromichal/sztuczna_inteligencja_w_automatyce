function [E, y_mod] = oblicz_blad_modelu_neuron(u, y, w10, w1, w20, w2, tryb)
kp=7;
N = length(u);
y_mod = zeros(N,1); % Inicjalizacja wektora wyjść modelu neuronowego

if tryb==1
    tryb='ARX';
elseif tryb==2
    tryb='OE';
end
% ukm6 = u(kp-6); ukm5 = u(kp-5); 
% ykm2 = y(kp-2); ykm1 = y(kp-1); 

% Pętla obliczeniowa dla całej trajektorii
for k = kp:N
    if strcmp(tryb, 'ARX')
        ykm1 = y(k-1);
        ykm2 = y(k-2);
    elseif strcmp(tryb, 'OE')
        ykm1 = y_mod(k-1);
        ykm2 = y_mod(k-2);
    end
    ukm6 = u(k-6); ukm5 = u(k-5); 
    % Obliczenie wyjścia modelu neuronowego
    y_mod(k) = model_neuron(ukm5, ukm6, ykm1, ykm2, w10, w1, w20, w2);
    
    % Aktualizacja opóźnionych wartości wyjść
    
end

E=sum((y_mod(7:end)-y(7:end)).^2);
end
