function [ys]=odp_jedn_zakl_fun(kk, Tp, dFD, h2_lin, varargin)
    alpha1 = 20; alpha2 = 22;
    % Punkt pracy
    FDpp=14; F1pp=73; h2pp=h2_lin; h1pp=h2pp*(alpha2/alpha1)^2;
    if nargin >= 5
        F1pp = varargin{1};
    end
    F1in=F1pp;
    FD = FDpp + dFD;
    h0=[h1pp h2pp];
    tk=kk*Tp;
    h2_vals=[];
    h_k=h0;
    for k=1:kk
        % Wyznaczenie czasu dla chwili k do symulacji
        t_k=k*Tp;
        tspan_k=[t_k-Tp t_k];
                
        % Symulacja modelu liniowego dla chwili k
        [~, hk_vals] = skok_mod_lin(tspan_k, h_k, tk, F1in, FD, h2_lin, F1pp);
        h_k=hk_vals(end,:);
        h2_vals=[h2_vals;h_k(2)];
    end

    % Normalizacja odpowiedzi skokowej
    ys=(h2_vals-h2pp)/dFD;
end