steps = round(simtime/timestep);
dof = 2*length(nodes);
D = zeros(steps+1, dof);
Ddot = zeros(steps+1, dof);
Dddot = zeros(steps+1, dof);
F = zeros(steps+1, dof);

D(1,1:dof) = initial_disp(1:dof);
Ddot(1,1:dof) = initial_vel(1:dof);
Dddot(1,1:dof) = initial_accel(1:dof);

for i=1:length(nodes)
    for j=1:steps+1
        if j > length(nodes(i).fx)
            F(j,2*i-1) = F(j-1,2*i-1);
        else
            F(j,2*i-1) = nodes(i).fx(j);
        end
        if j > length(nodes(i).fy)
            F(j,2*i) = F(j-1,2*i);
        else
            F(j,2*i) = nodes(i).fy(j);
        end
    end
end
 
%% Builds system matrices
disp('Building global stiffness matrix...');
Kglobal = zeros(3*length(nodes));
for i=1:length(elements)
    [k11, k12, k22, index1, index2] = elements(i).decomposeStiffnes();
    k21 = transpose(k12);
    
    index1 = 3 * (index1 - 1);
    index2 = 3 * (index2 - 1);
    
    for j = 1:3
        for k = 1:3
            Kglobal(index1 + j, index1 + k) = Kglobal(index1 + j, index1 + k) + k11(j, k);
            Kglobal(index1 + j, index2 + k) = Kglobal(index1 + j, index2 + k) + k12(j, k);
            Kglobal(index2 + j, index1 + k) = Kglobal(index2 + j, index1 + k) + k21(j, k);
            Kglobal(index2 + j, index2 + k) = Kglobal(index2 + j, index2 + k) + k22(j, k);
        end
    end
end

disp('Done')
disp('Building global mass matrix...');
Mglobal = zeros(3*length(nodes));
for i=1:length(elements)
    [m11, m12, m22, index1, index2] = elements(i).decomposeMass();
    m21 = transpose(m12);
    
    index1 = 3 * (index1 - 1);
    index2 = 3 * (index2 - 1);

    for j = 1:3
        for k = 1:3
            Mglobal(index1 + j, index1 + k) = Mglobal(index1 + j, index1 + k) + m11(j, k);
            Mglobal(index1 + j, index2 + k) = Mglobal(index1 + j, index2 + k) + m12(j, k);
            Mglobal(index2 + j, index1 + k) = Mglobal(index2 + j, index1 + k) + m21(j,k);
            Mglobal(index2 + j, index2 + k) = Mglobal(index2 + j, index2 + k) + m22(j,k);
        end
    end
end
disp('Done')

Cglobal = 0.0004 * (0.3*Mglobal + 0.03*Kglobal);
