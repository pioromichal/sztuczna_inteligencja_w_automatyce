clear; close all;
addpath("dane");
load("dane_ucz.mat")
load("dane_wer.mat");
set(0, 'DefaultAxesFontName', 'Arial');
set(0, 'DefaultTextFontName', 'Arial');

pp = 7; % próbka początkowa
pk = length(y_ucz); % próbka końcowa

%% uczenie modelu liniowego
M = zeros(pk-6,4);

% for i = pp:pk
%     M(i-6,:)=[u_ucz(i-5), u_ucz(i-6), y_ucz(i-1),y_ucz(i-2)];
% end

M(:,1) = u_ucz(pp-5:pk-5); % u(k-5)
M(:,2) = u_ucz(pp-6:pk-6); % u(k-6)
M(:,3) = y_ucz(pp-1:pk-1); % y(k-1)
M(:,4) = y_ucz(pp-2:pk-2); % y(k-2)

w = M\y_ucz(pp:pk);

%% ARX sprawdzenie dla danych uczących

y_mod = M*w;

figure; hold on; grid on; grid minor; xlabel('y_{ucz}'); ylabel('y_{mod}');
plot(y_ucz(pp:pk),y_mod,'.');

figure; hold on; grid on; grid minor; xlabel('k'); ylabel('y');
plot(1:pk,y_ucz,'.'); plot(pp:pk,y_mod,'.'); legend('y_{ucz}','y_{mod}', Location='best');

E = (y_mod-y_ucz(pp:pk))'*(y_mod-y_ucz(pp:pk));
disp(['E ucz ARX = ' num2str(E)]);

%% ARX sprawdzenie dla danych weryfikujących

M(:,1) = u_wer(pp-5:pk-5); % u(k-5)
M(:,2) = u_wer(pp-6:pk-6); % u(k-6)
M(:,3) = y_wer(pp-1:pk-1); % y(k-1)
M(:,4) = y_wer(pp-2:pk-2); % y(k-2)

y_mod = M*w;

figure; hold on; grid on; grid minor; xlabel('y_{wer}'); ylabel('y_{mod}')
plot(y_wer(pp:pk),y_mod,'.');

figure; hold on; grid on; grid minor; xlabel('k'); ylabel('y');
plot(1:pk,y_wer,'.'); plot(pp:pk,y_mod,'.'); legend('y_{wer}','y_{mod}', Location='best');

E = (y_mod-y_wer(pp:pk))'*(y_mod-y_wer(pp:pk));
disp(['E wer ARX = ' num2str(E)]);

%% OE dla danych uczących

y_mod = zeros(pk,1);
y_mod(1:pp) = y_ucz(1:pp);
for k = pp:pk
    y_mod(k) = [u_ucz(k-5),u_ucz(k-6),y_mod(k-1),y_mod(k-2)]*w;
end

E = (y_mod-y_ucz)'*(y_mod-y_ucz);
disp(['E ucz OE = ' num2str(E)]);

figure; hold on; grid on; grid minor; xlabel('k'); ylabel('y');
plot(1:pk,y_ucz,'.'); plot(1:pk,y_mod,'.'); legend('y_{ucz}','y_{mod}', Location='best');
exportgraphics(gcf, 'Wykresy/z2_8_OE_sym_ucz.pdf', 'ContentType', 'vector');

figure; hold on; grid on; grid minor; xlabel('y_{ucz}'); ylabel('y_{mod}');
plot(y_ucz,y_mod,'.');
exportgraphics(gcf, 'Wykresy/z2_8_OE_ymod(yucz).pdf', 'ContentType', 'vector');

%% OE dla danych weryfikujących

y_mod = zeros(pk,1);
y_mod(1:pp) = y_wer(1:pp);
for k = pp:pk
    y_mod(k) = [u_wer(k-5),u_wer(k-6),y_mod(k-1),y_mod(k-2)]*w;
end

E = (y_mod-y_wer)'*(y_mod-y_wer);
disp(['E wer OE = ' num2str(E)]);

figure; hold on; grid on; grid minor; xlabel('k'); ylabel('y');
plot(1:pk,y_wer,'.'); plot(1:pk,y_mod,'.'); legend('y_{wer}','y_{mod}', Location='best');
exportgraphics(gcf, 'Wykresy/z2_8_OE_sym_wer.pdf', 'ContentType', 'vector');

figure; hold on; grid on; grid minor; xlabel('y_{wer}'); ylabel('y_{mod}');
plot(y_wer,y_mod,'.');
exportgraphics(gcf, 'Wykresy/z2_8_OE_ymod(ywer).pdf', 'ContentType', 'vector');