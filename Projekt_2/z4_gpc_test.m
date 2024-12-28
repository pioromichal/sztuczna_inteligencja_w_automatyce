clear; close all;

%% Parametry regulatora

N = 100;
Nu = 100;
lambda = 10000;

%% Odpowiedź skokowa
w = [0.0981;-0.0929;1.9199;-0.9220]; % b5 b6 -a1 -a2

u(1) = 0; u(2:N+7) = 1;
ys = zeros(N+2,1);
for k = 7:N+2
    ys(k) = [u(k-5),u(k-6),ys(k-1),ys(k-2)]*w;
end
ys(1:2)=[];

%% Parametry regulatora i wyznaczenie macierzy sterowania

M = zeros(N,Nu);
for col=1:Nu
    M(col:N,col) = ys(1:N-col+1);
end

K = (M.'*M + lambda*eye(Nu,Nu))\M.';

clear col du k u ys lambda Nu M

%% Symulacja działania regulatora
kk = 1000;
umin = -1;
umax = 1;

x1km1=0;x2km1=0;
y(1:kk)=0; u(1:kk)=0; 
yzad(1:20)=0; yzad(21:300)=0.2;yzad(301:600)=-0.1;yzad(601:kk)=-2;

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
    delta_U = K*(Yzad - Y0');
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