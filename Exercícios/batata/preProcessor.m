disp('Building global stiffness matrix...');
Kglobal = zeros(2*length(nodes));
for i=1:length(elements)
    Kdist = zeros(2*length(nodes));
    [k11, k12, k22, index1, index2] = elements(i).decomposeToGlobal();
    index1 = 2 * index1 -1;
    index2 = 2 * index2 -1;
    Kdist(index1,index1) = k11(1,1);
    Kdist(index1,index1+1) = k11(1,2);
    Kdist(index1+1,index1) = k11(2,1);
    Kdist(index1+1,index1+1) = k11(2,2);
    
    Kdist(index1,index2) = k12(1,1);
    Kdist(index1,index2+1) = k12(1,2);
    Kdist(index1+1,index2) = k12(2,1);
    Kdist(index1+1,index2+1) = k12(2,2);
    
    Kdist(index2,index1) = k12(1,1);
    Kdist(index2,index1+1) = k12(1,2);
    Kdist(index2+1,index1) = k12(2,1);
    Kdist(index2+1,index1+1) = k12(2,2);
    
    Kdist(index2,index2) = k22(1,1);
    Kdist(index2,index2+1) = k22(1,2);
    Kdist(index2+1,index2) = k22(2,1);
    Kdist(index2+1,index2+1) = k22(2,2);
    
    Kglobal = Kglobal + Kdist;
end
disp('Done')

F = zeros(length(nodes),1);
for i=1:length(nodes)
    F(2*i - 1) = nodes(i).fx;
    F(2*i) = nodes(i).fy;
end



