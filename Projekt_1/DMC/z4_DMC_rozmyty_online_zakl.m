function [t, h_vals, F1in_vals]=z4_DMC_rozmyty_online_zakl(kk, Tp, ke_r, ku_r,kz_r, D, Dz, ...
    h2zad_val, FD, punkty_rozmycia)
    h2zad = @(t) h2zad_val;
    % Punkt pracy
    FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;
    kk=kk+1;
    % Warunki początkowe symulacji
    h_vals=[h1pp, h2pp];
    t=0;
    du_p(1:D-1)=0;
    delta_z_p(1:Dz)=0;
    u_p=F1pp;
    F1in_vals(1:kk) = F1pp;
    % FD_vals(1:kk) = FD;
    FD_vals(1:9) = FDpp;
    FD_vals(10:kk) = FD;
    for k=2:kk
        % Wyznaczenie czasu dla chwili k do symulacji
        t_k=k*Tp;
        tspan_k=[t_k-Tp t_k];

        % Aktualizacja przeszłych przyrostów zakłócenia
        for m=Dz-1:-1:2
            delta_z_p(m) = delta_z_p(m-1);
        end
        % Zmiana zakłócenia
        delta_z_p(1) = FD_vals(k) - FD_vals(k-1);

        % Wyznaczenie nowej wartości sterowania regulatora DMC
        hk=h_vals(end,:);
        du = z4_DMC_rozmyty_du_zakl(punkty_rozmycia, hk(2),h2zad(t_k),ke_r,ku_r,kz_r,du_p',delta_z_p');

        % Ograniczenia wartości sygnału sterującego
        if u_p+du < 0
            du = 0-u_p;
        end

        u=u_p+du;
        F1in_vals(k)=u;
        u_p=u;

        % Aktualizacja wektora przyrostów przeszłych
        du_p=[du, du_p(1:end-1)];

        if k<kk
            % Rozwiąż równania ODE
            [tk, hk_vals] = skok_mod_nlin(tspan_k, hk, Tp, F1in_vals, FD_vals);
            % h_vals=[h_vals;hk_vals(2:end,:)];
            h_vals=[h_vals;hk_vals(end,:)];
            t=[t;tk(2:end,:)];
        end
    end




end