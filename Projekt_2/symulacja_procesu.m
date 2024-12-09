function [x1, x2, y] = symulacja_procesu(x1km1,x2km1,ukm5)

alpha1 = -1.272717; alpha2 = 0.332871; 
beta1 = 0.028400; beta2 = 0.019723;

g1 = (exp(5.25*ukm5)-1)/(exp(5.25*ukm5)+1);
% g2 to dokładnie y

x1 = -alpha1 * x1km1 + x2km1 + beta1*g1;
x2 = -alpha2 * x1km1 + beta2 * g1;
y = 0.8*(1-exp(-2*x1));

end