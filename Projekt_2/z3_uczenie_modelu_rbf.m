clear;
load dane\dane_ucz;

edopuszcz = 0.00001;
tau = 5;

% Przygotowanie danych uczących
[U_ucz, Y_ucz] = przygotuj_dane(u_ucz, y_ucz, tau);

% Uczenie modelu
sn = newrb(U_ucz', Y_ucz', edopuszcz, 1, 30, 1);

% Zapisanie modelu do pliku
if ~exist('modele', 'dir')
    mkdir('modele');
end
save('modele/model_rbf.mat', 'sn');
disp('Model został zapisany w pliku modele/model_rbf.mat');

function [U, Y] = przygotuj_dane(u, y, tau)
    Y = y(tau + 2:end);
    U = [];
    for k = tau+2:length(y)
        U = [U; u(k-tau), u(k-tau-1), y(k-1), y(k-2)];
    end
end