disp('Building global stiffness matrix...');
Kglobal = sparse(2*length(nodes),2*length(nodes));
for i=1:length(elements)
    [Klocal, Mlocal, index1, index2, index3, index4] = elements(i).decomposeMatrices();
       
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

F = sparse(2*length(nodes),1);
for i=1:length(nodes)
    F(2*i - 1) = nodes(i).fx(end);
    F(2*i) = nodes(i).fy(end);
end

clear i j k positions Klocal Mlocal index1 index2 index3 index4