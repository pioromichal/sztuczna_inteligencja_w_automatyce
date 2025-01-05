clear; close all;

%% Parametry regulatora

% strojony_parametr = 'lam'; % N Nu lam ; 3 spacje sa istotne

N = 40;
Nu = 5;
lambda = 15;

N_vals = [50,40,30,20];
Nu_vals = [7,6,5,4];
lambda_vals = [15,10,9,8,7];


load("modele\sieci\model_K6_alg_BFGS_tryb_OE.mat"); % w10, w1, w20, w2

%% Symulacja działania regulatora
z4_trajektoria_zadana;

kk = length(yzad);
umin = -1;
umax = 1;

h1 = figure; hold on; xlabel('k');ylabel('u'); grid on; grid minor;
h2 = figure; hold on; xlabel('k');ylabel('y'); grid on; grid minor;

strojony_parametr = 'lam'; % N Nu lam ; 3 spacje sa istotne

% for N = N_vals
% Nu = N;

% for Nu = Nu_vals

for lambda = lambda_vals


[y,u] = z4_npl_funkcja(N,Nu,lambda, yzad);

if  strojony_parametr == 'N  ', dispname = ['N=' num2str(N)];end
if  strojony_parametr == 'Nu ', dispname = ['Nu=' num2str(Nu)];end
if  strojony_parametr == 'lam', dispname = ['\lambda=' num2str(lambda)];end

figure(h1);
plot(u, DisplayName=dispname);

figure(h2);
plot(y, DisplayName=dispname);

E = (yzad - y)*(yzad-y)';
disp(['Dla N=' num2str(N) ', Nu=' num2str(Nu) ', lambda=' num2str(lambda) ': E=' num2str(E)]);

end

figure(h1); legend show; legend Location southeast ;
if  strojony_parametr == 'N  ', exportgraphics(gcf, 'Wykresy/z4_NPL_50-20_50-20_15_u.pdf', 'ContentType', 'vector'); end
if  strojony_parametr == 'Nu ', exportgraphics(gcf, 'Wykresy/z4_NPL_40_10-4_15_u.pdf', 'ContentType', 'vector');end
if  strojony_parametr == 'lam', exportgraphics(gcf, 'Wykresy/z4_NPL_40_5_15_u.pdf', 'ContentType', 'vector'); end


figure(h2); stairs(yzad, '--', DisplayName='yzad'); legend show; legend Location southeast ;
if  strojony_parametr == 'N  ', exportgraphics(gcf, 'Wykresy/z4_NPL_50-20_50-20_15_y.pdf', 'ContentType', 'vector'); end
if  strojony_parametr == 'Nu ', exportgraphics(gcf, 'Wykresy/z4_NPL_40_10-4_15_y.pdf', 'ContentType', 'vector'); end
if  strojony_parametr == 'lam', exportgraphics(gcf, 'Wykresy/z4_NPL_40_5_15_y.pdf', 'ContentType', 'vector'); end