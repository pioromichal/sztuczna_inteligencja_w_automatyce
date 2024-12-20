K = 10;                   % Liczba neuronów w warstwie ukrytej
alg_uczacy = 2;           % Algorytm uczący: 1 - najszybszy spadek, 2 - BFGS
tryb_uczenia = 2;         % Tryb uczenia: 1 - ARX, 2 - OE
liczba_prob = 5;          % Liczba prób

% [W10, W1, W20, W2]=trenowanie_sieci(K, alg_uczacy, tryb_uczenia, liczba_prob);

[w10, w1, w20, w2, E_ucz, E_wer] = ...
    wybor_sieci(W10, W1, W20, W2, tryb_uczenia);

generuj_wykresy_por_sieci(w10, w1, w20, w2, tryb_uczenia)