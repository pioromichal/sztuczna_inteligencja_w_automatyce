function [du] = z2_DMC_rozmyty_online(parametry_rozmycia, y,yzad,ke_r,ku_r,du_p)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

mi = fun_przyn_trap(y, parametry_rozmycia, 5);

du = 0;
ilosc_modeli = length(ke_r);
for i = 1:ilosc_modeli
    du = du + mi(i)*DMC_du(y,yzad,ke_r(i),ku_r(i,:),du_p);
end

end