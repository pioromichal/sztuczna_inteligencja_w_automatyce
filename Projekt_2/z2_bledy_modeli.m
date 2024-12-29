disp('Błędy modeli uczonych BFGS w OE')
alg_uczacy = 2; 
tryb_uczenia = 2; 
K_max = 10;
[E_ucz_2_2, E_wer_2_2] = oblicz_bledy_modeli_neuron(alg_uczacy, tryb_uczenia, K_max);


disp('Błędy modeli uczonych najszybszym spadkiem w OE')
alg_uczacy = 1; 
tryb_uczenia = 2; 
K_max = 10;

[E_ucz_1_2, E_wer_1_2] = oblicz_bledy_modeli_neuron(alg_uczacy, tryb_uczenia, K_max);

disp('Błędy modeli uczonych BFGS w ARX')
alg_uczacy = 2; 
tryb_uczenia = 1; 
K_max = 10;

[E_ucz_2_1, E_wer_2_1] = oblicz_bledy_modeli_neuron(alg_uczacy, tryb_uczenia, K_max);