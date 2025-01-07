clear;
load dane\dane_ucz;

% Parametry
edopuszcz = 0.00001;
max_neurony = 100;

% Trenowanie modelu
for e_pow=1:7
    edopuszcz=10^(-e_pow);
    [sn]=trenuj_siec_rbf(u_ucz, y_ucz, edopuszcz, max_neurony);
end