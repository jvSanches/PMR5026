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
    Kdist = zeros(3*length(nodes));
    [k11, k12, k22, index1, index2] = elements(i).decomposeStiffnes();
    k21 = transpose(k12);
    index1 = 3 * index1 -2;
    index2 = 3 * index2 -2;
    Kdist(index1,index1) = k11(1,1);
    Kdist(index1,index1+1) = k11(1,2);
    Kdist(index1,index1+2) = k11(1,3);
    Kdist(index1+1,index1) = k11(2,1);
    Kdist(index1+1,index1+1) = k11(2,2);
    Kdist(index1+1,index1+2) = k11(2,3);
    Kdist(index1+2,index1) = k11(3,1);
    Kdist(index1+2,index1+1) = k11(3,2);
    Kdist(index1+2,index1+2) = k11(3,3);
    
    Kdist(index1,index2) = k12(1,1);
    Kdist(index1,index2+1) = k12(1,2);
    Kdist(index1,index2+2) = k12(1,3);
    Kdist(index1+1,index2) = k12(2,1);
    Kdist(index1+1,index2+1) = k12(2,2);
    Kdist(index1+1,index2+2) = k12(2,3);
    Kdist(index1+2,index2) = k12(3,1);
    Kdist(index1+2,index2+1) = k12(3,2);
    Kdist(index1+2,index2+2) = k12(3,3);
  
    Kdist(index2,index1) = k21(1,1);
    Kdist(index2,index1+1) = k21(1,2);
    Kdist(index2,index1+2) = k21(1,3);
    Kdist(index2+1,index1) = k21(2,1);
    Kdist(index2+1,index1+1) = k21(2,2);
    Kdist(index2+1,index1+2) = k21(2,3);
    Kdist(index2+2,index1) = k21(3,1);
    Kdist(index2+2,index1+1) = k21(3,2);
    Kdist(index2+2,index1+2) = k21(3,3);
    
    Kdist(index2,index2) = k22(1,1);
    Kdist(index2,index2+1) = k22(1,2);
    Kdist(index2,index2+2) = k22(1,3);
    Kdist(index2+1,index2) = k22(2,1);
    Kdist(index2+1,index2+1) = k22(2,2);
    Kdist(index2+1,index2+2) = k22(2,3);
    Kdist(index2+2,index2) = k22(3,1);
    Kdist(index2+2,index2+1) = k22(3,2);
    Kdist(index2+2,index2+2) = k22(3,3);
    
     
    disp(Kdist);
    
    Kglobal = Kglobal + Kdist;
end
disp('Done')
disp('Building global mass matrix...');
Mglobal = zeros(3*length(nodes));
for i=1:length(elements)
    Mdist = zeros(3*length(nodes));
    [m11, m12, m22, index1, index2] = elements(i).decomposeMass();
    m21 = transpose(m12);
    index1 = 3 * index1 -2;
    index2 = 3 * index2 -2;
    Mdist(index1,index1) = m11(1,1);
    Mdist(index1,index1+1) = m11(1,2);
    Mdist(index1,index1+2) = m11(1,3);
    Mdist(index1+1,index1) = m11(2,1);
    Mdist(index1+1,index1+1) = m11(2,2);
    Mdist(index1+1,index1+2) = m11(2,3);
    Mdist(index1+2,index1) = m11(3,1);
    Mdist(index1+2,index1+1) = m11(3,2);
    Mdist(index1+2,index1+2) = m11(3,3);
    
    Mdist(index1,index2) = m12(1,1);
    Mdist(index1,index2+1) = m12(1,2);
    Mdist(index1,index2+2) = m12(1,3);
    Mdist(index1+1,index2) = m12(2,1);
    Mdist(index1+1,index2+1) = m12(2,2);
    Mdist(index1+1,index2+2) = m12(2,3);
    Mdist(index1+2,index2) = m12(3,1);
    Mdist(index1+2,index2+1) = m12(3,2);
    Mdist(index1+2,index2+2) = m12(3,3);
  
    Mdist(index2,index1) = m21(1,1);
    Mdist(index2,index1+1) = m21(1,2);
    Mdist(index2,index1+2) = m21(1,3);
    Mdist(index2+1,index1) = m21(2,1);
    Mdist(index2+1,index1+1) = m21(2,2);
    Mdist(index2+1,index1+2) = m21(2,3);
    Mdist(index2+2,index1) = m21(3,1);
    Mdist(index2+2,index1+1) = m21(3,2);
    Mdist(index2+2,index1+2) = m21(3,3);
    
    Mdist(index2,index2) = m22(1,1);
    Mdist(index2,index2+1) = m22(1,2);
    Mdist(index2,index2+2) = m22(1,3);
    Mdist(index2+1,index2) = m22(2,1);
    Mdist(index2+1,index2+1) = m22(2,2);
    Mdist(index2+1,index2+2) = m22(2,3);
    Mdist(index2+2,index2) = m22(3,1);
    Mdist(index2+2,index2+1) = m22(3,2);
    Mdist(index2+2,index2+2) = m22(3,3);
        
    
    Mglobal = Mglobal + Mdist;
end
disp('Done')

Cglobal = 0.0004 * (0.3*Mglobal + 0.03*Kglobal);
