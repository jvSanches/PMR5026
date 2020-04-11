disp('Building global stiffness matrix...');
Kglobal = zeros(3*length(nodes));
for i=1:length(elements)
    Kdist = zeros(3*length(nodes));
    [k11, k12, k22, index1, index2] = elements(i).decomposeStiffnes();
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
    
    Kdist(index1,index2) = k11(1,1);
    Kdist(index1,index2+1) = k11(1,2);
    Kdist(index1,index2+2) = k11(1,3);
    Kdist(index1+1,index2) = k11(2,1);
    Kdist(index1+1,index2+1) = k11(2,2);
    Kdist(index1+1,index2+2) = k11(2,3);
    Kdist(index1+2,index2) = k11(3,1);
    Kdist(index1+2,index2+1) = k11(3,2);
    Kdist(index1+2,index2+2) = k11(3,3);
  
    Kdist(index2,index1) = k11(1,1);
    Kdist(index2,index1+1) = k11(1,2);
    Kdist(index2,index1+2) = k11(1,3);
    Kdist(index2+1,index1) = k11(2,1);
    Kdist(index2+1,index1+1) = k11(2,2);
    Kdist(index2+1,index1+2) = k11(2,3);
    Kdist(index2+2,index1) = k11(3,1);
    Kdist(index2+2,index1+1) = k11(3,2);
    Kdist(index2+2,index1+2) = k11(3,3);
    
    Kdist(index2,index2) = k11(1,1);
    Kdist(index2,index2+1) = k11(1,2);
    Kdist(index2,index2+2) = k11(1,3);
    Kdist(index2+1,index2) = k11(2,1);
    Kdist(index2+1,index2+1) = k11(2,2);
    Kdist(index2+1,index2+2) = k11(2,3);
    Kdist(index2+2,index2) = k11(3,1);
    Kdist(index2+2,index2+1) = k11(3,2);
    Kdist(index2+2,index2+2) = k11(3,3);
    
     
    disp(Kdist);
    
    Kglobal = Kglobal + Kdist;
end
disp('Done')

F = zeros(length(nodes),1);
for i=1:length(nodes)
    F(3*i - 2) = nodes(i).fx;
    F(3*i-1) = nodes(i).fy;
    F(3*i) = nodes(i).Mo;
end

