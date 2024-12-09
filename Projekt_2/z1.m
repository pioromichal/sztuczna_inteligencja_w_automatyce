clear; close all;
kk = 200;

u(1:50)=0; u(51:100)=1; u(101:150)=-1; u(151:kk)=0;

x1km1=0;x2km1=0;
for k = 1:kk
    [x1km1, x2km1, y(k)] = symulacja_procesu(x1km1,x2km1,u(k));
end



figure;
plot(y,'.'); hold on;