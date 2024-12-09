clear; close all;
kk = 4000;
dlugosc_skoku = 100;
ilosc_skokow = kk/dlugosc_skoku - 1;

%% dane uczące
losowe_wartosci = -1 + 2 * rand(1, 40);
u_ucz = zeros(kk,1);
for i = 1:ilosc_skokow
    zakres = (1:dlugosc_skoku) + (dlugosc_skoku*i);
    u_ucz(zakres) = losowe_wartosci(i);
end

x1km1=0;x2km1=0;
y_ucz = zeros(kk,1);
for k = 1:kk
    [x1km1, x2km1, y_ucz(k)] = symulacja_procesu(x1km1,x2km1,u_ucz(k));
end

figure; hold on;
plot(y_ucz,'.');
plot(u_ucz);



%% dane weryfikujące
losowe_wartosci = -1 + 2 * rand(1, ilosc_skokow);
u_wer = zeros(kk,1);
for i = 1:ilosc_skokow
    zakres = (1:dlugosc_skoku)+(dlugosc_skoku*i);
    u_wer(zakres) = losowe_wartosci(i);
end

x1km1=0;x2km1=0;
y_wer = zeros(kk,1);
for k = 1:kk
    [x1km1, x2km1, y_wer(k)] = symulacja_procesu(x1km1,x2km1,u_wer(k));
end

figure; hold on;
plot(y_wer,'.');
plot(u_wer);
