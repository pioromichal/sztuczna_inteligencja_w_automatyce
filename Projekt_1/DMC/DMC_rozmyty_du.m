function [du] = DMC_rozmyty_du(parametry_rozmycia, y,yzad,ke_r,ku_r,du_p)
    h2pp=15.6384;
    mi = fun_przyn_trap(y, parametry_rozmycia, 0.1*h2pp);
    
    du = 0;
    ilosc_modeli = length(ke_r);
    for i = 1:ilosc_modeli
        du = du + mi(i)*DMC_du(y,yzad,ke_r(i),ku_r(i,:),du_p);
    end

end