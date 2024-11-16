function [ys]=odp_jedn_fun(kk, Tp, dF1in, h2_lin)

    % Punkt pracy
    FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225;

    F1in=F1pp+dF1in;
    h0=[h1pp h2pp];
    tk=kk*Tp;
    h2_vals=[];
    h_k=h0;
    for k=1:kk
        % Wyznaczenie czasu dla chwili k do symulacji
        t_k=k*Tp;
        tspan_k=[t_k-Tp t_k];
                
        % Symulacja modelu liniowego dla chwili k
        [~, hk_vals] = skok_mod_lin(tspan_k, h_k, tk, F1in, FDpp, h2_lin);
        h_k=hk_vals(end,:);
        h2_vals=[h2_vals;h_k(2)];
    end

    % Normalizacja odpowiedzi skokowej
    ys=(h2_vals-h2pp)/dF1in;
end