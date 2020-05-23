steps = round(simtime/timestep);
dof = 2*length(nodes);
D = zeros(steps+1, dof);
Ddot = zeros(steps+1, dof);
Dddot = zeros(steps+1, dof);
F = zeros(steps+1, dof);

if initial_disp     
    D(1,1:dof) = initial_disp(1:dof);
end
if initial_vel
    Ddot(1,1:dof) = initial_vel(1:dof);
end
if initial_acc
    Dddot(1,1:dof) = initial_acc(1:dof);
end

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
Kglobal = zeros(2*length(nodes),2*length(nodes));
Mglobal = zeros(2*length(nodes));

for i=1:length(elements)
    [Klocal, Mlocal, index1, index2, index3, index4] = elements(i).decomposeMatrices();
       
    positions = [2*index1 - 1, 2*index2 - 1, 2*index3 - 1,2*index4 - 1];
    
    for j = 1:4
        for k = 1:4 
            
            Kglobal(positions(j),positions(k)) = Kglobal(positions(j),positions(k)) + Klocal(2*j-1,2*k-1);
            Kglobal(positions(j),positions(k)+1) = Kglobal(positions(j),positions(k)+1) + Klocal(2*j-1,2*k);
            Kglobal(positions(j)+1,positions(k)) = Kglobal(positions(j)+1,positions(k)) + Klocal(2*j,2*k-1);
            Kglobal(positions(j)+1,positions(k)+1) = Kglobal(positions(j)+1,positions(k)+1) + Klocal(2*j,2*k);
            
            Mglobal(positions(j),positions(k)) = Mglobal(positions(j),positions(k)) + Mlocal(2*j-1,2*k-1);
            Mglobal(positions(j),positions(k)+1) = Mglobal(positions(j),positions(k)+1) + Mlocal(2*j-1,2*k);
            Mglobal(positions(j)+1,positions(k)) = Mglobal(positions(j)+1,positions(k)) + Mlocal(2*j,2*k-1);
            Mglobal(positions(j)+1,positions(k)+1) = Mglobal(positions(j)+1,positions(k)+1) + Mlocal(2*j,2*k);
        end
    end
end
disp('Done')

% disp('Building global mass matrix...');
% Mglobal = zeros(3*length(nodes));
% for i=1:length(elements)
%     [m11, m12, m22, index1, index2] = elements(i).decomposeMass();
%     m21 = transpose(m12);
%     
%     index1 = 3 * (index1 - 1);
%     index2 = 3 * (index2 - 1);
% 
%     for j = 1:3
%         for k = 1:3
%             Mglobal(index1 + j, index1 + k) = Mglobal(index1 + j, index1 + k) + m11(j, k);
%             Mglobal(index1 + j, index2 + k) = Mglobal(index1 + j, index2 + k) + m12(j, k);
%             Mglobal(index2 + j, index1 + k) = Mglobal(index2 + j, index1 + k) + m21(j,k);
%             Mglobal(index2 + j, index2 + k) = Mglobal(index2 + j, index2 + k) + m22(j,k);
%         end
%     end
% end
% disp('Done')

Cglobal = 0.0004 * (0.3*Mglobal + 0.03*Kglobal);
