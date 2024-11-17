function [ke_r, ku_r] = z2_DMC_rozmyty_offline(parametry_rozmycia, Tp)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% ???
dF1in=10;
% h2_lin = 15.5; % tymczasowe, poźniej należy dobrakć h2_lin dla każdego modelu osobno

liczba_modeli = length(parametry_rozmycia);

if liczba_modeli == 2
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=1; % DMC parametry
    h2_lin = parametry_rozmycia(1); % punkt linearyzacji do odpowiedzi skokowej
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin); % Model odpowiedzi skokowej
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D); % DMC obliczenia offline 

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=1;
    h2_lin = parametry_rozmycia(2);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D);

    ke_r = [ke_r1, ke_r2];
    ku_r = [ku_r1; ku_r2];

elseif liczba_modeli == 3
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(1);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D);

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=1;
    h2_lin = parametry_rozmycia(2);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D);

    % DMC nr 3
    N=70; Nu=70; D=140; lambda=1;
    h2_lin = parametry_rozmycia(3);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r3, ku_r3] = DMC_offline(ys,N,Nu,lambda,D);

    ke_r = [ke_r1, ke_r2, ke_r3];
    ku_r = [ku_r1; ku_r2; ku_r3];

elseif liczba_modeli == 4
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=1;
    h2_lin = parametry_rozmycia(1);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(2);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 3
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(3);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r3, ku_r3] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 4
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(4);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r4, ku_r4] = DMC_offline(ys,N,Nu,lambda,D); 

    ke_r = [ke_r1, ke_r2, ke_r3, ke_r4];
    ku_r = [ku_r1; ku_r2; ku_r3; ku_r4];

elseif liczba_modeli == 5
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(1);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(2);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 3
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(3);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r3, ku_r3] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 4
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(4);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r4, ku_r4] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 5
    N=70; Nu=70; D=140; lambda=1; 
    h2_lin = parametry_rozmycia(5);
    ys=odp_jedn_fun(D, Tp, dF1in, h2_lin);
    [ke_r5, ku_r5] = DMC_offline(ys,N,Nu,lambda,D); 

    ke_r = [ke_r1, ke_r2, ke_r3, ke_r4, ke_r5];
    ku_r = [ku_r1; ku_r2; ku_r3; ku_r4; ku_r5];

end
end