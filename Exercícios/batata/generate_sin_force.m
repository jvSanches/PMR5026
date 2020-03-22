T = 0.0128;
w = 2*pi/T;
timestep = 0.00001;
t = 0:timestep:T/2;
A = 7500000;

D = zeros(length(t),2);
D(:,2) = A*sin(w*t);