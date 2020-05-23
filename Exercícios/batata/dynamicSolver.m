disp('Starting Solver')

%% Reduces system with given constraits

for i=1:length(nodes)
    if nodes(i).xconstrained
        
        for j = 1:length(Kglobal)
            F(:, j) = F(:, j) - Kglobal(j,2*i-1) * nodes(i).dx;
            Kglobal(2*i-1,j) = 0;
            Kglobal(j,2*i-1) = 0;       
            Mglobal(2*i-1,j) = 0;
            Mglobal(j,2*i-1) = 0;    
            Cglobal(2*i-1,j) = 0;
            Cglobal(j,2*i-1) = 0;  
        end
        F(:,2*i-1) = nodes(i).dx;
        Kglobal(2*i-1, 2*i-1) = 1;
        Mglobal(2*i-1, 2*i-1) = 1;
        Cglobal(2*i-1, 2*i-1) = 1;
        
    end
    if nodes(i).yconstrained
        for j = 1:length(Kglobal)
            F(:, j) = F(:, j) - Kglobal(j,2*i) * nodes(i).dy;
            Kglobal(2*i,j) = 0;
            Kglobal(j,2*i) = 0;           
            Mglobal(2*i,j) = 0;
            Mglobal(j,2*i) = 0;   
            Cglobal(2*i,j) = 0;
            Cglobal(j,2*i) = 0;   
        end
        F(:,2*i) = nodes(i).dy;
        Kglobal(2*i, 2*i) = 1;
        Mglobal(2*i, 2*i) = 1;
        Cglobal(2*i, 2*i) = 1;
    end
end

%% Solve by Newmark
D = D'; Ddot = Ddot'; Dddot = Dddot'; F = F'; % Transpose matrices
tp(1) = 0;
gamma = 1/2;
beta = 1/4;
A = (1/(beta*timestep^2))*Mglobal+(gamma/(beta*timestep))*Cglobal+Kglobal; % cálculo de K’
invA= inv(A);
Dddot(:,1) = inv(Mglobal)*(F(:,1)-Cglobal*Ddot(:,1)-Kglobal*D(:,1));
for i= 1:steps
    B = (F(:,i+1)+...
        Mglobal*((1/(beta*timestep^2))*D(:,i)+(1/(beta*timestep))*Ddot(:,i)+ ...
        (1/(2*beta)-1)*Dddot(:,i))+Cglobal*((gamma/(beta*timestep))*D(:,i)+...
        (gamma/beta-1)*Ddot(:,i)+(gamma/beta-2)*(timestep/2)*Dddot(:,i)));% cálculo de F’
    D(:,i+1) = invA*B;
    Dddot(:,i+1) = (1/(beta*timestep^2))*(D(:,i+1)-D(:,i))...
        -(1/(beta*timestep))*Ddot(:,i)-((1/(2*beta))-1)*Dddot(:,i);
    Ddot(:,i+1) = Ddot(:,i)+(1-gamma)*timestep*Dddot(:,i)+gamma*timestep*Dddot(:,i+1);
    tp(i+1) = tp(i)+timestep;
end
D = D'; Ddot = Ddot'; Dddot = Dddot'; F = F'; % Transpose matrices back

clear i A B gamma beta invA