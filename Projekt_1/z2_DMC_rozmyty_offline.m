function [ke_r, ku_r] = z2_DMC_rozmyty_offline(punkty_rozmycia, lambdy, Tp)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% ???

dF1in=10;

liczba_modeli = length(punkty_rozmycia);
ke_r = [];
ku_r = [];

for i = 1:liczba_modeli

    % dF1in=-10;
    % 
    % F1 = - 73 + 22*sqrt(punkty_rozmycia(i))-14;

    N=70; Nu=70; D=140; lambda=lambdy(i); % DMC parametry
    h2_lin = punkty_rozmycia(i); % punkt linearyzacji do odpowiedzi skokowej
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin); % Model odpowiedzi skokowej
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D); % DMC obliczenia offline
    ke_r = [ke_r, ke_r1];
    ku_r = [ku_r; ku_r1];
end

end