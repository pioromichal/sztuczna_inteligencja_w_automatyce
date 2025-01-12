clear; close all;

%%
kk = 200;
us = -1:0.01:1;

alpha1 = -1.272717; alpha2 = 0.332871; 
beta1 = 0.028400; beta2 = 0.019723;

for i = 1:length(us)
    u = us(i);
    g1 = (exp(5.25*u)-1)/(exp(5.25*u)+1);
    x1 = g1*(beta1+beta2)/(1+alpha1+alpha2);
    y(i) = 0.8*(1-exp(-2*x1));
end

figure; hold on;
plot(us, y, LineWidth=1);

%%
% clear; close all;
clear y us 
addpath("dane");
load("dane_ucz.mat")
load("dane_wer.mat");
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');

pp = 7; % próbka początkowa
pk = length(y_ucz); % próbka końcowa

M = zeros(pk-6,4);

M(:,1) = u_ucz(pp-5:pk-5); % u(k-5)
M(:,2) = u_ucz(pp-6:pk-6); % u(k-6)
M(:,3) = y_ucz(pp-1:pk-1); % y(k-1)
M(:,4) = y_ucz(pp-2:pk-2); % y(k-2)

w = M\y_ucz(pp:pk);

kk = 200;
us = -1:0.01:1;
y(1:kk) = 0;
for i = 1:length(us)
    u = us(i);
    for k = 3:kk
        y(k) = [u,u,y(k-1),y(k-2)]*w;
    end
    ysmk(i) = y(end);
end

% figure; hold on;
plot(us, ysmk, LineWidth=1);

%%
xlabel('u');
ylabel('y');
grid on; grid minor;
legend('Obiekt', 'Model liniowy', Location='best');
file_name = sprintf('Wykresy/z2_8_statyka_lin.pdf');
exportgraphics(gcf, file_name, 'ContentType', 'vector');