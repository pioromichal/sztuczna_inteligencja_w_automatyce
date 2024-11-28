function [ke_r, ku_r] = DMC_rozmyty_offline(punkty_rozmycia, ...
    N,Nu,lambda,D, Tp)
    dF1in=10;
    liczba_modeli = length(punkty_rozmycia);
    ke_r = [];
    ku_r = [];
    
    for i = 1:liczba_modeli
        % % DMC parametry
        % N=70; Nu=70; D=140; lambda=lambdy(i); 
        % punkt linearyzacji do odpowiedzi skokowej
        h2_lin = punkty_rozmycia(i); 
        % F1 w punkcie pracy linearyzacji
        F1pp = znajdz_F1pp(h2_lin);
        % Model odpowiedzi skokowej
        ys=odp_jedn_fun(D, Tp, dF1in, h2_lin, F1pp);
        % DMC obliczenia offline
        [ke_r1, ku_r1] = DMC_offline(ys,N(i),Nu(i),lambda(i),D); 
        ke_r = [ke_r, ke_r1];
        ku_r = [ku_r; ku_r1];
    end
end