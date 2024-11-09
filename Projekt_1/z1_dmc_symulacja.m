clear all;
addpath('DMC');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;

% Parametry symulacji
Tp=20; kk=150;

% Wartość zadana
h2zad_val = 20;
h2zad = @(t) h2zad_val;

% DMC parametry
N=25; Nu=27; D=1200; lambda=2;

% DMC obliczenia offline
ys=odp_jedn_fun(D, Tp, dF1in, F1pp, FDpp, h1pp, h2pp);
[K1, ke, ku, Mp] = DMC_offline(ys,N,Nu,lambda,D);

% Warunki początkowe symulacji
h_vals=[h1pp, h2pp];
t=0;
du_p(1:D-1)=0;
u_p=F1pp;
F1in_vals(1:kk) = F1pp;
FD_vals(1:kk) = FDpp;

for k=1:kk
    % Wyznaczenie czasu dla chwili k do symulacji
    t_k=k*Tp;
    tspan_k=[t_k-Tp t_k];

    % Wyznaczenie nowej wartości sterowania regulatora DMC
    hk=h_vals(end,:);
    du=DMC_du(hk(2),h2zad(t_k),ke,ku,du_p');
    u=u_p+du;
    F1in_vals(k)=u;
    u_p=u;

    % Aktualizacja wektora przyrostów przeszłych
    du_p=[du, du_p(1:end-1)];
    
    if k<kk
        % Rozwiąż równania ODE
        [tk, hk_vals] = skok_mod_nlin(tspan_k, hk, Tp, F1in_vals, FD_vals, F1pp, FDpp);
        h_vals=[h_vals;hk_vals(2:end,:)];
        t=[t;tk(2:end,:)];
    end
end

% Wyświetlenie wyników
figure;
% plot(t, h_vals(:,1), '-', t, h_vals(:,2), ':');
plot(t, h_vals(:,2));
hold on;
plot(t, h2zad_val*ones(length(t)),'-');
legend('h2(t)', 'h_zad');
xlabel('Czas (t)');
ylabel('Wysokości (h1, h2)');
title('Sygnał wyjściowy dla DMC jednowymiarowego');
grid on; grid minor;


figure;
stairs(1:Tp:Tp*kk, F1in_vals);
legend('F1in(t)');
xlabel('Czas (t)');
ylabel('Sygnał sterujący');
title('Sygnał sterujący dla DMC jednowymiarowego');
grid on; grid minor;