close all
clear all

dt = 0.5;
t_fim = 4;
n = (t_fim/dt)+1;

g = -9.8;
h0 = 50;
v0 = 0;
vn = v0 + g*t_fim;

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
K = K*(1/dt);

f_int = ones(n,1);
f_int(2:n-1) = 2;
f_int = -(g*dt/2)*f_int;

f_ext = zeros(n,1);
f_ext(1) = v0;
f_ext(n) = vn;

F = f_int + f_ext;

K_util = K(2:n, 2:n);
F_util = F(2:n) - K(1,2:end)'*h0;
u_util = linsolve(K_util,F_util);

u = [h0; u_util];
tx = 0:dt:t_fim;
plot(tx, u)
title("Deslocamento ao longo do tempo")
ylabel("Altura (m)")
xlabel("Tempo (s)")

hold on
fplot(@(t) h0 + v0*t + g*t^2/2, [0,t_fim]) 
