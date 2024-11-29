function [du] = z4_DMC_rozmyty_du_zakl(parametry_rozmycia, y,yzad,ke_r,ku_r,kz_r,du_p,delta_z_p)
    h2pp=15.6384;
    mi = fun_przyn_trap(y, parametry_rozmycia, 0.1*h2pp);
    du = 0;
    ilosc_modeli = length(ke_r);
    e=yzad-y;
% du = ke*e - ku*du_p;
    for i = 1:ilosc_modeli
        % du = du + mi(i)*DMC_du(y,yzad,ke_r(i),ku_r(i,:),du_p);
        du = du + mi(i)*(ke_r(i)*e - ku_r(i,:)*du_p - kz_r(i,:)*delta_z_p);
    end

end