function delta_u = z4_DMC_online_numeryczny_zakl(modele, modele_z, punkty_rozmycia, D, Dz, N, Nu, lambda, yzad, yk, ukm1, delta_u_p, delta_z)

mi = fun_przyn_trap(yk,punkty_rozmycia, 3);

ys = zeros(size(D));
for i=1:length(mi)
    ys = ys + modele{i}*mi(i); 
end

yz = zeros(size(D));
for i=1:length(mi)
    yz = yz + modele_z{i}*mi(i); 
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

% Konstrukcja macierzy Mpz
Mpz = zeros(N,Dz-1);
Mpz(:,1)=yz(1:N);
for j = 2:Dz
    for i = 1:N
        c = min([i+j-1,Dz]);
        Mpz(i,j) = yz(c) - yz(j-1);
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

Y0k = Yk + Mp*delta_u_p+ Mpz*delta_z;

H = 2*(M'*M + lambda*eye(Nu,Nu));
f = -2*M'*(Yzad - Y0k);
J = tril(ones(Nu));
A = [-J; J; -M; M];
b = [-Umin+Ukm1; Umax-Ukm1; -Ymin+Y0k; Ymax-Y0k];

delta_U = quadprog(H,f,A,b);

if isempty(delta_U)
    disp(delta_U);
end

delta_u = delta_U(1);


end

