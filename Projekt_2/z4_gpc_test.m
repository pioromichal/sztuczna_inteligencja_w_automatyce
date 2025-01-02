clear; close all;

%% Parametry regulatora i modelu

N = 40;
Nu = 5;
lambda = 9;

b(5) = 0.0981;
b(6) = -0.0929;
a(1) = -1.9199;
a(2) = 0.9220;

% do wygodnego wykorzystania w równaniu różnicowym
w = [b(5);b(6);-a(1);-a(2)];

%% Odpowiedź skokowa

ys = zeros(N,1);
for p = 3:N
    for i = 1:min([p,6])
        ys(p) = ys(p)+b(i);
    end

    for i = 1:min([p,2])
        ys(p) = ys(p)-a(i)*ys(p-i);
    end
end

%% Wyznaczenie macierzy sterowania

M = zeros(N,Nu);
for col=1:Nu
    M(col:N,col) = ys(1:N-col+1);
end

K = (M'*M + lambda*eye(Nu,Nu))\M';

clear a b i p col du k ys lambda Nu M

%% Symulacja działania regulatora
z4_trajektoria_zadana;

kk = length(yzad);
umin = -1;
umax = 1;

x1km1=0;x2km1=0;
y(1:kk)=0; u(1:kk)=0; 
Y0 = zeros(N,1);

for k = 7:kk
    % pomiar (symulacja) y(k)
    [x1km1, x2km1, y(k)] = symulacja_procesu(x1km1,x2km1,u(k-5));
    
    % obliczenie zakłócenia dk
    dk = y(k) - [u(k-5),u(k-6),y(k-1),y(k-2)]*w;

    % odpowiedź swobodna Y0
    Y0(1) = [u(k-4),u(k-5),y(k),y(k-1)]*w +dk;
    Y0(2) = [u(k-3),u(k-4),Y0(1),y(k)]*w +dk;
    Y0(3) = [u(k-2),u(k-3),Y0(2),Y0(1)]*w +dk;
    Y0(4) = [u(k-1),u(k-2),Y0(3),Y0(2)]*w +dk;
    Y0(5) = [u(k-1),u(k-1),Y0(4),Y0(3)]*w +dk;
    for i = 6:N
        Y0(i) = [u(k-1),u(k-1),Y0(i-1),Y0(i-2)]*w +dk;
    end

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

figure;
plot(u);
xlabel('k');ylabel('u');

figure;hold on;
plot(y); plot(yzad);
xlabel('k');ylabel('y');

E = (yzad - y)*(yzad-y)';
disp(E);