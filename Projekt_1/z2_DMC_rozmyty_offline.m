function [ke_r, ku_r] = z2_DMC_rozmyty_offline(liczba_modeli, Tp)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% ???
dF1in=10;


if liczba_modeli == 2
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=10; % DMC parametry
    ys=odp_jedn_fun(D, Tp, dF1in); % Model odpowiedzi skokowej
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D); % DMC obliczenia offline 

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=10;
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D);

    ke_r = [ke_r1, ke_r2];
    ku_r = [ku_r1; ku_r2];

elseif liczba_modeli == 3
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=0.5; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D);

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=1;
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D);

    % DMC nr 3
    N=70; Nu=70; D=140; lambda=2;
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r3, ku_r3] = DMC_offline(ys,N,Nu,lambda,D);

    ke_r = [ke_r1, ke_r2, ke_r3];
    ku_r = [ku_r1; ku_r2; ku_r3];

elseif liczba_modeli == 4
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=10;
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 3
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r3, ku_r3] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 4
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r4, ku_r4] = DMC_offline(ys,N,Nu,lambda,D); 

    ke_r = [ke_r1, ke_r2, ke_r3, ke_r4];
    ku_r = [ku_r1; ku_r2; ku_r3; ku_r4];

elseif liczba_modeli == 5
    % DMC nr 1
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r1, ku_r1] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 2
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r2, ku_r2] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 3
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r3, ku_r3] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 4
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r4, ku_r4] = DMC_offline(ys,N,Nu,lambda,D); 

    % DMC nr 5
    N=70; Nu=70; D=140; lambda=10; 
    ys=odp_jedn_fun(D, Tp, dF1in);
    [ke_r5, ku_r5] = DMC_offline(ys,N,Nu,lambda,D); 

    ke_r = [ke_r1, ke_r2, ke_r3, ke_r4, ke_r5];
    ku_r = [ku_r1; ku_r2; ku_r3; ku_r4; ku_r5];

end
end