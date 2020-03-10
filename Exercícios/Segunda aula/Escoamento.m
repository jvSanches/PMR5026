mi = 16e-6;
D = 0.1;
P_grad = -3e-4;


L = D/4;

K = (mi/L)*[1 -1 0 0 0; -1 2 -1 0 0; 0 -1 2 -1 0; 0 0 -1 2 -1; 0 0 0 -1 1];

u1 = 0;
u5 = 0;
dudyx1= 0;
dudyx5= 0;

(P_grad * L /2 ) * [1; 2; 2; 2; 1] + [-dudyx1; 0; 0; 0; -dudyx5];
