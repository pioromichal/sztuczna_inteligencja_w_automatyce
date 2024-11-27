function [du] = DMC_rozmyty_du(parametry_rozmycia, y,yzad,ke_r,ku_r,du_p)
    mi = fun_przyn_trap(y, parametry_rozmycia, 2);
    
    du = 0;
    ilosc_modeli = length(ke_r);
    for i = 1:ilosc_modeli
        du = du + mi(i)*DMC_du(y,yzad,ke_r(i),ku_r(i,:),du_p);
    end

end