function delta_u = z3_DMC_online_numeryczny(modele, punkty_rozmycia, D, N, Nu, lambda, yzad, yk, ukm1, delta_u_p)

mi = fun_przyn_trap(yk,punkty_rozmycia, 5);

ys = zeros(size(D));
for i=1:length(mi)
    ys = ys + modele{i}*mi(i); 
end


M = zeros(N,Nu);
for col=1:Nu
    M(col:N,col) = ys(1:N-col+1);
end

Mp = zeros(N,D-1);
for j = 1:D-1
    for i = 1:N
        c = min([i+j,D]);
        Mp(i,j) = ys(c) - ys(j);
    end
end



umin = 0;
umax = 150;
ymin = 0;
ymax = 50;

Umin= umin * ones(Nu, 1);
Umax = umax * ones(Nu, 1);
Ukm1 = ukm1 * ones(Nu,1);

Ymin= ymin * ones(N, 1);
Ymax = ymax * ones(N, 1);
Yzad = yzad * ones(N, 1);
Yk = yk * ones(N, 1);

Y0k = Yk + Mp*delta_u_p;

H = 2*(M'*M + lambda);
f = -2*M'*(Yzad - Yk - Mp*delta_u_p);
J = tril(ones(Nu));
A = [-J; J; -M; M];
b = [-Umin+Ukm1; Umax-Ukm1; -Ymin+Y0k; Ymax-Y0k];

delta_U = quadprog(H,f,A,b,[],[],-1*ones(Nu,1),1*ones(Nu,1));
% delta_U = quadprog(H,f,A,b);

if isempty(delta_U)
    disp(delta_U);
end

delta_u = delta_U(1);


end

