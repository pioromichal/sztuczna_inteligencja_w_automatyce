clear; close all;
kk = 200;
us = -1:0.01:1;

for i = 1:length(us)
    u = us(i);
    x1km1=0;x2km1=0;
    for k = 1:kk
        [x1, x2, y] = symulacja_procesu(x1km1,x2km1,u);
        x1km1 = x1; 
        x2km1 = x2;
    end
    ys(i) = y(end);
end

figure; hold on;
plot(us, ys, LineWidth=1);


% statyka wyznaczona analitycznie, aby mieć pewność że model został
% wyznaczony poprawnie 

alpha1 = -1.272717; alpha2 = 0.332871; 
beta1 = 0.028400; beta2 = 0.019723;

for i = 1:length(us)
    u = us(i);
    g1 = (exp(5.25*u)-1)/(exp(5.25*u)+1);
    x1 = g1*(beta1+beta2)/(1+alpha1+alpha2);
    y(i) = 0.8*(1-exp(-2*x1));
end

colors = lines(3);
plot(us, y, '--', LineWidth=1, Color=colors(3,:));

% colors = lines(3);
xlabel('u');
ylabel('y');
grid on; grid minor;
legend('Metoda ekperymentalna', 'Metoda analityczna', Location='best');
file_name = sprintf('Wykresy/z1_statyka.pdf');
exportgraphics(gcf, file_name, 'ContentType', 'vector');