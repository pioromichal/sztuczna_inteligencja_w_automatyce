function [ke,ku,kz]=z4_DMC_offline_zakl(ys,yz,N,Nu,lambda,D,Dz)

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



K = (M.'*M + lambda*eye(Nu,Nu))\M.';
K1 = K(1,:);
ke = sum(K1);
ku = K1*Mp;

kz = K1 * Mpz;

end