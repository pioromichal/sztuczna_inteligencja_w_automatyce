% Parametry modelu uczonego BFGS w trybie OE
K = 6;
alg_ucz = 2;
tryb_ucz = 2;

generuj_wykresy_por_sieci(tryb_ucz, K, alg_ucz, tryb_ucz);

% Parametry modelu uczonego najszybszym spadkiem w trybie OE
K = 4;
alg_ucz = 1;
tryb_ucz = 2;

generuj_wykresy_por_sieci(tryb_ucz, K, alg_ucz, tryb_ucz);

% Parametry modelu uczonego BFGS w trybie ARX
K = 8;
alg_ucz = 2;
tryb_ucz = 1;

generuj_wykresy_por_sieci(tryb_ucz, K, alg_ucz, tryb_ucz);
generuj_wykresy_por_sieci(2, K, alg_ucz, tryb_ucz);
