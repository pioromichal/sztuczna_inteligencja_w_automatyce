clear all;
addpath('DMC');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;

% Parametry symulacji
tk=2500; Tp=10; kk=round(tk/Tp);

% DMC parametry
N=70; Nu=70; D=140; lambda=10;

% DMC obliczenia offline
ys=odp_jedn_fun(D, Tp, dF1in, F1pp, FDpp, h1pp, h2pp);
[K1, ke, ku, Mp] = DMC_offline(ys,N,Nu,lambda,D);



for dh2zad_sign=[-1 , 1]
for dh2zad_per=[10, 20, 50]
    % Wartość zadana
    h2zad_val=h2pp*(1+dh2zad_sign*dh2zad_per/100);
    h2zad = @(t) h2zad_val;

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
            % h_vals=[h_vals;hk_vals(2:end,:)];
            h_vals=[h_vals;hk_vals(end,:)];
            t=[t;tk(2:end,:)];
        end
    end
    
    % Wyświetlenie wyników w jednym oknie
    figure;
    
    % Pierwszy wykres - Sygnał wyjściowy
    % subplot(2, 1, 1);
    % plot(t, h_vals(:,2));
    plot(1:Tp:kk*Tp, h_vals(:,2));
    hold on;
    plot(1:Tp:kk*Tp, h2zad_val * ones(length(kk+1)), '--');
    legend('h2(t)', 'h_{zad}');
    xlabel('Czas (t)');
    ylabel('Wysokość h_2');
    title('Sygnał wyjściowy DMC jednowymiarowego');
    grid on; grid minor;
    
    % Drugi wykres - Sygnał sterujący
    % subplot(2, 1, 2);
    % stairs(1:Tp:Tp*kk, F1in_vals);
    % legend('F1in(t)');
    % xlabel('Czas (t)');
    % ylabel('Sygnał sterujący');
    % title('Sygnał sterujący DMC jednowymiarowego');
    % grid on; grid minor;
    
    file_name = sprintf('wykresy/Zad1/symulacja_DMC_j_zmiana_h2_zad_o_%+d_procent.pdf', dh2zad_sign * dh2zad_per);
    
    % Export wykresu do pliku .pdf
    exportgraphics(gcf, file_name, 'ContentType', 'vector');
    close all;
end
end