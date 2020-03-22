disp('Starting Solver')

%% Reduces system with given constraits

for i=1:length(nodes)
    if nodes(i).xconstrained
        
        for j = 1:length(Kglobal)
            F(j) = F(j) - Kglobal(j,2*i-1) * nodes(i).dx;
            Kglobal(2*i-1,j) = 0;
            Kglobal(j,2*i-1) = 0;       
            Mglobal(2*i-1,j) = 0;
            Mglobal(j,2*i-1) = 0;    
        end
        F(:,2*i-1) = nodes(i).dx;
        Kglobal(2*i-1, 2*i-1) = 1;
        Mglobal(2*i-1, 2*i-1) = 1;
    end
    if nodes(i).yconstrained
        for j = 1:length(Kglobal)
            F(j) = F(j) - Kglobal(j,2*i) * nodes(i).dy;
            Kglobal(2*i,j) = 0;
            Kglobal(j,2*i) = 0;           
            Mglobal(2*i,j) = 0;
            Mglobal(j,2*i) = 0;   
        end
        F(:,2*i) = nodes(i).dy;
        Kglobal(2*i, 2*i) = 1;
        Mglobal(2*i, 2*i) = 1;
    end
end

M_inv = (Mglobal./timestep^2)^-1;
MC1 = (2/timestep^2)*Mglobal - (1/timestep)*Cglobal;
MC2 = (1/timestep^2)*Mglobal - (1/timestep)*Cglobal;

D0 = D(1,:) - timestep*Ddot(1,:) + (timestep^2/2)*Dddot(1,:);
D(2, :) = M_inv*(F(1,:)' + (Kglobal - MC1)*D(1,:)' - MC2*D0');
for i=2:steps-1
    D(i+1,:) = M_inv*(F(i,:)' + (Kglobal - MC1)*D(i,:)' - MC2*D(i-1,:)');
end