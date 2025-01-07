% Parametry regulatora
N = 50;
Nu = 5;
lambda = 15;
load("modele\sieci\model_K6_alg_BFGS_tryb_OE.mat"); % w10, w1, w20, w2

% Symulacja działania regulatora
z4_trajektoria_zadana;

kk = length(yzad);
umin = -1;
umax = 1;
dumult = 0.05;
dumin = umin*dumult;
dumax = umax*dumult;


x1km1 = 0;
x2km1 = 0;
y(1:kk) = 0;
u(1:kk) = 0;

% Wstępne przypisanie zmiany sterowania
du = zeros(Nu, 1);  % Wektor zmian sterowania
du_opt = zeros(Nu, 1);  % Optymalna zmiana sterowania
lb = repmat(dumin, Nu, 1);  % Dolna granica sterowania
ub = repmat(dumax, Nu, 1);  % Górna granica sterowania

% Opcje dla fmincon
options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');


% Pętla optymalizacji
for k = 7:kk
    % pomiar (symulacja) y(k)
    [x1km1, x2km1, y(k)] = symulacja_procesu(x1km1, x2km1, u(k-5));

    % Obliczanie zakłócenia dk
    dk = y(k) - model_neuron(u(k-5), u(k-6), y(k-1), y(k-2), w10, w1, w20, w2);

    % Funkcje do fminocona
    fun = @(du) funkcja_celu_NO(du, k, u, y, yzad(k), dk, w10, w1, w20, w2, N, Nu, lambda);
    ograniczenia_fun = @(du) ograniczenia_NO(du, u, umin, umax, k);
    
    % Przeprowadzenie optymalizacji
    du = [du_opt(2:Nu);du_opt(Nu)];
    [du_opt, fval] = fmincon(fun, du, [], [], [], [], lb, ub, ograniczenia_fun, options);  % Optymalizacja
    fprintf('Iteracja %d: Błąd = %.4f\n', k, fval);
    % Zaktualizowanie sterowania
    u(k) = u(k-1) + du_opt(1);  % Zastosowanie optymalnego sterowania
end

% Wykresy wyników
figure;
plot(u);
xlabel('k'); ylabel('u');

figure; hold on;
plot(y); stairs(yzad);
xlabel('k'); ylabel('y');

% Obliczanie błędu
E = (yzad - y)*(yzad - y)';
disp(E);





