disp('Building global stiffness matrix...');
Kglobal = sparse(2*length(nodes),2*length(nodes));
for i=1:length(elements)
    [Klocal, index1, index2, index3, index4] = elements(i).decomposeStiffnes();
       
    positions = [2*index1 - 1, 2*index2 - 1, 2*index3 - 1,2*index4 - 1];
    
    for j = 1:4
        for k = 1:4 
            
            Kglobal(positions(j),positions(k)) = Kglobal(positions(j),positions(k)) + Klocal(2*j-1,2*k-1);
            Kglobal(positions(j),positions(k)+1) = Kglobal(positions(j),positions(k)+1) + Klocal(2*j-1,2*k);
            Kglobal(positions(j)+1,positions(k)) = Kglobal(positions(j)+1,positions(k)) + Klocal(2*j,2*k-1);
            Kglobal(positions(j)+1,positions(k)+1) = Kglobal(positions(j)+1,positions(k)+1) + Klocal(2*j,2*k);
            
        end
    end
    

end
disp('Done')

if modal_analysis
    disp('Building global mass matrix...');
    Mglobal = sparse(3*length(nodes), 3*length(nodes));
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
end

F = sparse(length(nodes),1);
for i=1:length(nodes)
    F(3*i - 2) = nodes(i).fx;
    F(3*i-1) = nodes(i).fy;
    F(3*i) = nodes(i).mo;
end

clear i index1 index2 k11 k12 k21 k22 m11 m12 m21 m22 Kdist Mdist