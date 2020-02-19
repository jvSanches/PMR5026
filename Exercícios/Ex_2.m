clear all
close all
syms x x_1 x_2 rho g A L

N1 = (x_2-x)/(L/4);
N2 = (x-x_1)/(L/4);
F = rho*g*A*(2-x/L);
F_1 = int(F*N1,x_1,x_2);
F_2 = int(F*N2,x_1,x_2);

F = [F_1; F_2];

L_ = 300;
A_ = 80;
P_ = 45;
E_ = 72;
g_ = 9.8;
rho_ = 2.7000E-06;

x_ = linspace(0,L_,5);
F1 = subs(F,[A,L,rho,g,x_1,x_2],[A_,L_,rho_,g_,x_(1), x_(2)]);
F2 = subs(F,[A,L,rho,g,x_1,x_2],[A_,L_,rho_,g_,x_(2), x_(3)]);
F3 = subs(F,[A,L,rho,g,x_1,x_2],[A_,L_,rho_,g_,x_(3), x_(4)]);
F4 = subs(F,[A,L,rho,g,x_1,x_2],[A_,L_,rho_,g_,x_(4), x_(5)]);

syms R u2 u3 u4 u5
K = (E_*A_/L_)*[15/2 -15/2 0 0 0; -15/2 14 -13/2 0 0; 0 -13/2 12 -11/2 0; 0 0 -11/2 10 -9/2; 0 0 0 -9/2 9/2];
F = [F1(1) + R; F1(2) + F2(1); F2(2) + F3(1); F3(2) + F4(1); F4(2) + P_];

K(1,:) = 0;
K(:,1) = 0;
K(1,1) = 1;
F(1) = 0;

u = double(linsolve(K,F));

fplot(@(x) ((P_*L_)/(E_*A_))*log((2*L_)/(2*L_ - x)));
hold on
plot(x_,u,'*');

