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

figure;
plot(us, ys); hold on;