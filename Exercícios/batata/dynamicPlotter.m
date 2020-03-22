figure

scale = 10000;
%%Display nodes
max_x = -inf;
min_x = inf;
max_y = -inf;
min_y = inf;
for i = 1:steps
    clf
    hold on;
    grid on;  
    for j=1:length(nodes)
        nx = nodes(j).x + scale*D(i,2*j-1);
        ny = nodes(j).y + scale*D(i,2*j);
        max_x = max(max_x, nx);
        max_y = max(max_y, ny);
        min_x = min(min_x, nx);
        min_y = min(min_y, ny);
        if nodes(j).xconstrained
            if nodes(j).yconstrained
                scatter(nx, ny, 's', 'filled', 'red');
            else
                scatter(nx, ny, '>', 'filled', 'red');
            end
        else 
            if nodes(j).yconstrained
                scatter(nx, ny,'^' ,'red');
            else
                scatter(nx, ny, 'red');
            end
        end
        text(nx+0.1, ny+0.1, string(j));
    end
    offset = 1;
    axis([min_x-offset max_x+offset min_y-offset max_y+offset])
    
    title("Step: " + string(i));

    %display trusses
    for j=1:length(elements)
        line_x = [elements(j).n1.x+scale*D(i,2*elements(j).n1.index - 1), elements(j).n2.x+scale*D(i,2*elements(j).n2.index - 1)];
        line_y = [elements(j).n1.y+scale*D(i,2*elements(j).n1.index), elements(j).n2.y+scale*D(i,2*elements(j).n2.index)];
        line(line_x,line_y)
    end 
    
    pause(0.00001)
end

