function [ke_r, ku_r, kz_r] = z4_DMC_rozmyty_offline_zakl(punkty_rozmycia, ...
    N,Nu,lambda,D, Dz, Tp)
    dF1in=10; dFD = 20;
    liczba_modeli = length(punkty_rozmycia);
    ke_r = [];
    ku_r = [];
    kz_r = [];
    
    for i = 1:liczba_modeli
        % punkt linearyzacji do odpowiedzi skokowej
        h2_lin = punkty_rozmycia(i); 
        % F1 w punkcie pracy linearyzacji
        F1pp = znajdz_F1pp(h2_lin);
        % Model odpowiedzi skokowej
        ys=odp_jedn_fun(D, Tp, dF1in, h2_lin, F1pp);
        yz = odp_jedn_zakl_fun(D, Tp, dFD,h2_lin);
        % DMC obliczenia offline
        [ke_r1, ku_r1, kz_r1] = z4_DMC_offline_zakl(ys,yz,N(i),Nu(i),lambda(i),D, Dz); 
        ke_r = [ke_r, ke_r1];
        ku_r = [ku_r; ku_r1];
        kz_r = [kz_r; kz_r1];
    end
end