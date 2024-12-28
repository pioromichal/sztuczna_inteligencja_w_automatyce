K = 1;                   % Liczba neuronów w warstwie ukrytej
alg_uczacy = 1;           % Algorytm uczący: 1 - najszybszy spadek, 2 - BFGS
tryb_uczenia = 2;         % Tryb uczenia: 1 - ARX, 2 - OE
liczba_prob = 10;          % Liczba prób

E_wer_od_K = zeros(1,1:K);
E_ucz_od_K = zeros(1,1:K);

for K=1:10
    [W10, W1, W20, W2, Farx, Foe]=trenowanie_sieci(K, alg_uczacy, tryb_uczenia, liczba_prob);

    [w10, w1, w20, w2, E_ucz, E_wer, farx, foe] = ...
        wybor_sieci(W10, W1, W20, W2, Farx, Foe, tryb_uczenia);

    E_ucz_od_K(K) = E_ucz;
    E_wer_od_K(K) = E_wer;
    
    zapisz_model_neuron_do_pliku(w10, w1, w20, w2, K, alg_uczacy, tryb_uczenia, farx, foe);

    % close all;
end