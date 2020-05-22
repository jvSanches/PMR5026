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
    for j = 1:4
        if j==1 
            xja = elements(i).n1.x;
            dxja = elements(i).n1.dx;
            xjb = elements(i).n2.x;
            dxjb = elements(i).n2.dx;
            yja = elements(i).n1.y;
            dyja = elements(i).n1.dy;
            yjb = elements(i).n2.y;
            dyjb = elements(i).n2.dy;
        elseif j==2 
            xja = elements(i).n2.x;
            dxja = elements(i).n2.dx;
            xjb = elements(i).n3.x;
            dxjb = elements(i).n3.dx;
            yja = elements(i).n2.y;
            dyja = elements(i).n2.dy;
            yjb = elements(i).n3.y;
            dyjb = elements(i).n3.dy;
        elseif j==3 
            xja = elements(i).n3.x;
            dxja = elements(i).n3.dx;
            xjb = elements(i).n4.x;
            dxjb = elements(i).n4.dx;
            yja = elements(i).n3.y;
            dyja = elements(i).n3.dy;
            yjb = elements(i).n4.y;
            dyjb = elements(i).n4.dy;
        elseif j==4 
            xja = elements(i).n4.x;
            dxja = elements(i).n4.dx;
            xjb = elements(i).n1.x;
            dxjb = elements(i).n1.dx;
            yja = elements(i).n4.y;
            dyja = elements(i).n4.dy;
            yjb = elements(i).n1.y;
            dyjb = elements(i).n1.dy;
        end
        line_x = [xja+scale*dxja, xjb+scale*dxjb];
        line_y = [yja+scale*dyja, yjb+scale*dyjb];
        
        line(line_x,line_y)
    end
end
