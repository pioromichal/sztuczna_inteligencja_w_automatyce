function [y,u] = z4_npl_funkcja(N,Nu,lambda, yzad)

load("modele\sieci\model_K6_alg_BFGS_tryb_OE.mat"); % w10, w1, w20, w2

kk = length(yzad);
umin = -1;
umax = 1;

x1km1=0;x2km1=0;
y(1:kk)=0; u(1:kk)=0;


for k = 7:kk
    % pomiar (symulacja) y(k)
    [x1km1, x2km1, y(k)] = symulacja_procesu(x1km1,x2km1,u(k-5));
    
    % obliczenie zakłócenia dk
    dk = y(k) - model_neuron(u(k-5), u(k-6), y(k-1), y(k-2), w10, w1, w20, w2);

    % odpowiedź swobodna Y0
    Y0 = zeros(N,1);
    Y0(1) = model_neuron(u(k-4), u(k-5), y(k), y(k-1), w10, w1, w20, w2) +dk;
    Y0(2) = model_neuron(u(k-3), u(k-4), Y0(1), y(k), w10, w1, w20, w2) +dk;
    Y0(3) = model_neuron(u(k-2), u(k-3), Y0(2), Y0(1), w10, w1, w20, w2) +dk;
    Y0(4) = model_neuron(u(k-1), u(k-2), Y0(3), Y0(2), w10, w1, w20, w2) +dk;
    Y0(5) = model_neuron(u(k-1), u(k-1), Y0(4), Y0(3), w10, w1, w20, w2) +dk;
    for i = 6:N
        Y0(i) = model_neuron(u(k-1), u(k-1), Y0(i-1), Y0(i-2), w10, w1, w20, w2) +dk;
    end

    % Linearyzacja modelu
    f = model_neuron(u(k-5), u(k-6), y(k-1), y(k-2), w10, w1, w20, w2);

    sigma = 0.001;
    
    b5 = (model_neuron(u(k-5)+sigma, u(k-6), y(k-1), y(k-2), w10, w1, w20, w2) - f)/sigma;
    b6 = (model_neuron(u(k-5), u(k-6)+sigma, y(k-1), y(k-2), w10, w1, w20, w2) - f)/sigma;
    a1 = -(model_neuron(u(k-5), u(k-6), y(k-1)+sigma, y(k-2), w10, w1, w20, w2) - f)/sigma;
    a2 = -(model_neuron(u(k-5), u(k-6), y(k-1), y(k-2)+sigma, w10, w1, w20, w2) - f)/sigma;

    wl = [b5;b6;a1;a2];

    b(5) = b5; b(6) = b6;
    a(1) = a1; a(2) = a2;

    % odpowiedź skokowa modelu
    ys = zeros(N,1);
    for p = 3:N
        for i = 1:min([p,6])
            ys(p) = ys(p)+b(i);
        end

        for i = 1:min([p,2])
            ys(p) = ys(p)-a(i)*ys(p-i);
        end
    end

    % wyznaczenie macierzy M
    M = zeros(N,Nu);
    for col=1:Nu
        M(col:N,col) = ys(1:N-col+1);
    end

    % wyznaczenie macierzy K
    K = (M'*M + lambda*eye(Nu,Nu))\M';

    % obliczenie wektora delta_u
    Yzad = yzad(k)*ones(N,1);
    delta_U = K*(Yzad - Y0);
    delta_u = delta_U(1);

    % ograniczenia
    if u(k-1)+delta_u < umin
        delta_u = umin-u(k-1);
    elseif u(k-1)+delta_u > umax
        delta_u = umax-u(k-1);
    end

    % wysłanie sygnału
    u(k)=u(k-1)+delta_u;

end
end