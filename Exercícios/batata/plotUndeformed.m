figure
hold on;
grid on;

%%Display nodes
max_x = -inf;
min_x = inf;
max_y = -inf;
min_y = inf;
for i=1:length(nodes)
    nx = nodes(i).x;
    ny = nodes(i).y;
    max_x = max(max_x, nx);
    max_y = max(max_y, ny);
    min_x = min(min_x, nx);
    min_y = min(min_y, ny);
    if nodes(i).constrained
        scatter(nx, ny, 'filled', 'red');
    else 
        scatter(nx, ny, 'red');
    end
    text(nx+0.1, ny+0.1, string(i));
end
offset = 1;
axis([min_x-offset max_x+offset min_y-offset max_y+offset])

%display trusses
for i=1:length(elements)
    line_x = [elements(i).n1.x, elements(i).n2.x];
    line_y = [elements(i).n1.y, elements(i).n2.y];
    line(line_x,line_y)
end
