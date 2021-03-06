disp('Starting Solver')

%% Reduces system with given constraits

for i=1:length(nodes)
    if nodes(i).xconstrained
        
        for j = 1:length(Kglobal)
            F(j) = F(j) - Kglobal(j,2*i-1) * nodes(i).dx;
            Kglobal(2*i-1,j) = 0;
            Kglobal(j,2*i-1) = 0;  
        end
        F(2*i-1) = nodes(i).dx;
        Kglobal(2*i-1, 2*i-1) = 1;
    end
    if nodes(i).yconstrained
        for j = 1:length(Kglobal)
            F(j) = F(j) - Kglobal(j,2*i) * nodes(i).dy;
            Kglobal(2*i,j) = 0;
            Kglobal(j,2*i) = 0;                       
        end
        F(2*i) = nodes(i).dy;
        Kglobal(2*i, 2*i) = 1;

    end
%     if nodes(i).thetaconstrained
%         for j = 1:length(Kglobal)
%             F(j) = F(j) - Kglobal(j,3*i) * nodes(i).dtheta;
%             Kglobal(3*i,j) = 0;
%             Kglobal(j,3*i) = 0;                       
%         end
%         F(3*i) = nodes(i).dtheta;
%         Kglobal(3*i, 3*i) = 1;
% 
%     end        
end

if modal_analysis
    for i=1:length(nodes)
        if nodes(i).xconstrained
            for j = 1:length(Mglobal)
                Mglobal(3*i-2,j) = 0;
                Mglobal(j,3*i-2) = 0;  
            end
            Mglobal(3*i-2, 3*i-2) = 1;
        end
        if nodes(i).yconstrained
            for j = 1:length(Mglobal)
                Mglobal(3*i-1,j) = 0;
                Mglobal(j,3*i-1) = 0;                       
            end
            Mglobal(3*i-1, 3*i-1) = 1;

        end
        if nodes(i).thetaconstrained
            for j = 1:length(Mglobal)
                Mglobal(3*i,j) = 0;
                Mglobal(j,3*i) = 0;                       
            end
            Mglobal(3*i, 3*i) = 1;

        end        
    end
    return
end

D = linsolve(full(Kglobal),full(F));

for i=1:length(nodes)
    nodes(i).dx = D(2*i-1);
    nodes(i).dy = D(2*i);
%     nodes(i).dtheta = D(3*i);
end

clear i j

disp('Done..')
