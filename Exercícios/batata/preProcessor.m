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

    Kglobal = Kglobal + Kdist;
end
disp('Done')

if modal_analysis
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
end

F = zeros(length(nodes),1);
for i=1:length(nodes)
    F(3*i - 2) = nodes(i).fx;
    F(3*i-1) = nodes(i).fy;
    F(3*i) = nodes(i).mo;
end

