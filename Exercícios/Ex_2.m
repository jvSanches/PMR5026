clear all
close all
%% Cálculo da matriz de rigidez
syms E A L

x_i = linspace(0,L,5);
xm_i = [x_i(2) + x_i(1), x_i(3) + x_i(2), x_i(4) + x_i(3), x_i(5) + x_i(4)]/2;
L_i = [L/4, L/4, L/4, L/4];
A_i = 2*A - xm_i*(A/L); 

K1 = (E*A_i(1)/(L_i(1)))*[1, -1; -1, 1];
K2 = (E*A_i(2)/(L_i(2)))*[1, -1; -1, 1];
K3 = (E*A_i(3)/(L_i(3)))*[1, -1; -1, 1];
K4 = (E*A_i(4)/(L_i(4)))*[1, -1; -1, 1];

K = [K1(1,1),           K1(1,2),                 0,                 0,       0;
     K1(2,1), K1(2,2) + K2(1,1),           K2(1,2),                 0,       0;
           0,           K2(2,1), K2(2,2) + K3(1,1),           K3(1,2),       0;
           0,                 0,           K3(2,1), K3(2,2) + K4(1,1), K4(1,2);
           0,                 0,                 0,           K4(2,1), K4(2,2)];

%% Cálculo do vetor de forças distribuídas
syms x_1 x_2 x rho g A R P

% Usando as funções de forma
N1 = (x_2-x)/(L/4);
N2 = (x-x_1)/(L/4);
F = rho*g*A*(2-x/L);
F_1 = int(F*N1,x_1,x_2);
F_2 = int(F*N2,x_1,x_2);

F = [F_1; F_2]; % Matriz de forças elementar

% Substituíndo para cada nó
F1 = subs(F,[x_1,x_2],[x_i(1), x_i(2)]);
F2 = subs(F,[x_1,x_2],[x_i(2), x_i(3)]);
F3 = subs(F,[x_1,x_2],[x_i(3), x_i(4)]);
F4 = subs(F,[x_1,x_2],[x_i(4), x_i(5)]);

% R é a força de reação, P é a força externa
Fg = [F1(1) + R; F1(2) + F2(1); F2(2) + F3(1); F3(2) + F4(1); F4(2) + P];

%% Cálculos numéricos
L = 300;
A = 80;
P = 45;
E = 72;
g = 9.8;
rho = 0; % rho = 0, pois desprezamos o peso próprio

% Substituindo valores
x_i = eval(x_i);
K = eval(K);
Fg = eval(Fg);

% Removendo o nó engastado
K(1,:) = 0;
K(:,1) = 0;
K(1,1) = 1;
Fg(1) = 0;

% Resolvendo o sistema linear
u = double(linsolve(K,Fg));

plot(x_i,u,'*-');
hold on
fplot(@(x) ((P*L)/(E*A))*log((2*L)/(2*L - x)), [0 300]);

legend( "Solução aproximada","Solução analítica")
legend('Location', 'NW')
xlabel("Posição do nó")
ylabel("Deslocamentos")
