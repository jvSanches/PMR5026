figure
hold on;
grid on;
scale = 100;

%%Display nodes
max_x = -inf;
min_x = inf;
max_y = -inf;
min_y = inf;
for i=1:length(nodes)
    nx = nodes(i).x+scale*nodes(i).dx;
    ny = nodes(i).y+scale*nodes(i).dy;
    max_x = max(max_x, nx);
    max_y = max(max_y, ny);
    min_x = min(min_x, nx);
    min_y = min(min_y, ny);
    if nodes(i).xconstrained
        if nodes(i).yconstrained
            scatter(nx, ny, 's', 'filled', 'red');
        else
            scatter(nx, ny, '>', 'filled', 'red');
        end
    else 
        if nodes(i).yconstrained
            scatter(nx, ny,'^' ,'red');
        else
            scatter(nx, ny, 'red');
        end
    end
    text(nx+0.1, ny+0.1, string(i));
end
offset = 1;
axis([min_x-offset max_x+offset min_y-offset max_y+offset])

%display trusses
for i=1:length(elements)
    line_x = [elements(i).n1.x+scale*elements(i).n1.dx, elements(i).n2.x+scale*elements(i).n2.dx];
    line_y = [elements(i).n1.y+scale*elements(i).n1.dy, elements(i).n2.y+scale*elements(i).n2.dy];
    line(line_x,line_y)
end
