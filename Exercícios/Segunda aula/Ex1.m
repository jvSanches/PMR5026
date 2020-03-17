clear all

n_elementos = 50;

%nós
n = n_elementos + 1;

mu = 16e-6;
h = 0.1;
dPdx = -3e-4;

L = h/(n_elementos);

K = zeros(n,n);

for i = 1:n
    for j = 1:n
        if i == j
           if i == 1 || i == n
               K(i,j) = 1;
           else
               K(i,j) = 2;
           end
        elseif (j == i-1 || j == i+1)
           K(i,j) = -1;
        end
    end
end
K = K*(mu/L);

f_int = ones(n,1);
f_int(2:n-1) = 2;
f_int = (dPdx*L/2)*f_int;

% Os 2 valores desonhecidos não importam, pois serão cancelados
f_ext = zeros(n,1);

F = f_int + f_ext;

K_util = K(2:n-1, 2:n-1);
F_util = F(2:n-1);
u_util = linsolve(K_util,F_util);

u = [0; u_util; 0];
y = h:-L:0;
plot(-u, y)
title("Perfil de velocidades")
ylabel("Altura(m)")
xlabel("Velocidade (m/s)")
hold on
