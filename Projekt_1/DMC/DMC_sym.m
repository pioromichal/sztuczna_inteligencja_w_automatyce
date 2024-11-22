function [y, u] = DMC_sym(kk, yzad, N, Nu, D, lambda, z)
    % Punkt pracy
    FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;
    h2_lin = h2pp;

    % Wartość zadana jako funkcja
    h2zad = @(t) yzad;
    
    % Parametry symulacji
    tk=2500; Tp=10; kk=round(tk/Tp);
    
    % DMC obliczenia offline
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke, ku] = DMC_offline(ys,N,Nu,lambda,D);

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