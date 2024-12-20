% clear; close all;
% kk = 4000;
% dlugosc_skoku = 100;
% ilosc_skokow = kk/dlugosc_skoku - 1;
% 
% %% dane uczące
% losowe_wartosci = -1 + 2 * rand(1, 40);
% u_ucz = zeros(kk,1);
% for i = 1:ilosc_skokow
%     zakres = (1:dlugosc_skoku) + (dlugosc_skoku*i);
%     u_ucz(zakres) = losowe_wartosci(i);
% end
% 
% x1km1=0;x2km1=0;
% y_ucz = zeros(kk,1);
% for k = 6:kk
%     [x1km1, x2km1, y_ucz(k)] = symulacja_procesu(x1km1,x2km1, ...
%         u_ucz(k-5));
% end
% 
% figure; hold on;
% plot(y_ucz,'.');
% stairs(u_ucz);
% 
% 
% 
% %% dane weryfikujące
% losowe_wartosci = -1 + 2 * rand(1, ilosc_skokow);
% u_wer = zeros(kk,1);
% for i = 1:ilosc_skokow
%     zakres = (1:dlugosc_skoku)+(dlugosc_skoku*i);
%     u_wer(zakres) = losowe_wartosci(i);
% end
% 
% x1km1=0;x2km1=0;
% y_wer = zeros(kk,1);
% for k = 6:kk
%     [x1km1, x2km1, y_wer(k)] = symulacja_procesu(x1km1,x2km1, ...
%         u_wer(k-5));
% end
% 
% figure; hold on;
% plot(y_wer,'.');
% stairs(u_wer);


%% wykresy zbioru uczącego
clear; close all;
addpath("dane\");

load("dane_ucz.mat");

figure; hold on;

subplot(2,1,1);
stairs(u_ucz);
ylabel('u_{ucz}');
grid on; grid minor;

subplot(2,1,2);
plot(y_ucz,'.');
ylabel('y_{ucz}');
xlabel('k');
ylim([-3.5 1])
grid on; grid minor;

file_name = sprintf('Wykresy/z1_dane_ucz.pdf');
exportgraphics(gcf, file_name, 'ContentType', 'vector');
% close;

%% wykresy zbioru weryfikujacego
% clear; close all;
addpath("dane\");

load("dane_wer.mat");

figure; hold on;

subplot(2,1,1);
stairs(u_wer, LineWidth=0.75);
ylabel('u_{wer}');
grid on; grid minor;

subplot(2,1,2);
plot(y_wer,'.');
ylabel('y_{wer}');
xlabel('k');
ylim([-3.5 1])
grid on; grid minor;

file_name = sprintf('Wykresy/z1_dane_wer.pdf');
exportgraphics(gcf, file_name, 'ContentType', 'vector');
% close;


%% Zapisanie danych u_ucz i y_ucz do pliku dane.txt
dataFilePath = fullfile('sieci', 'dane.txt'); % Ścieżka do pliku dane.txt
dataToSave = [u_ucz(:), y_ucz(:)];          % Łączenie wektorów w macierz (kolumny)

% Zapis do pliku
save(dataFilePath, 'dataToSave', '-ascii', '-double', '-tabs');
disp(['Dane zostały zapisane do pliku: ', dataFilePath]);
