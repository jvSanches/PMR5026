figure
fig = gcf;
scale = 100000;

disp("Plotting results")

for t = 1:round(steps/50):steps
    figure(fig)
    clf
    hold on;
    grid on;
    title("t = " + tp(t));
    %% Display nodes
    max_x = -inf;
    min_x = inf;
    max_y = -inf;
    min_y = inf;
    for i=1:length(nodes)
        nx = nodes(i).x + scale*D(t, 2*i - 1);
        ny = nodes(i).y + scale*D(t, 2*i);
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

    %% Display elements
    for i=1:length(elements)
        for j = 1:4
            if j==1 
                xja = elements(i).n1.x;
                dxja = D(t, elements(i).n1.index*2 - 1);
                xjb = elements(i).n2.x;
                dxjb = D(t, elements(i).n2.index*2 - 1);
                yja = elements(i).n1.y;
                dyja = D(t, elements(i).n1.index*2);
                yjb = elements(i).n2.y;
                dyjb = D(t, elements(i).n2.index*2);
            elseif j==2 
                xja = elements(i).n2.x;
                dxja = D(t, elements(i).n2.index*2 - 1);
                xjb = elements(i).n3.x;
                dxjb = D(t, elements(i).n3.index*2 - 1);
                yja = elements(i).n2.y;
                dyja = D(t, elements(i).n2.index*2);
                yjb = elements(i).n3.y;
                dyjb = D(t, elements(i).n3.index*2);
            elseif j==3 
                xja = elements(i).n3.x;
                dxja = D(t, elements(i).n3.index*2 - 1);
                xjb = elements(i).n4.x;
                dxjb = D(t, elements(i).n4.index*2 - 1);
                yja = elements(i).n3.y;
                dyja = D(t, elements(i).n3.index*2);
                yjb = elements(i).n4.y;
                dyjb = D(t, elements(i).n4.index*2);
            elseif j==4 
                xja = elements(i).n4.x;
                dxja = D(t, elements(i).n4.index*2 - 1);
                xjb = elements(i).n1.x;
                dxjb = D(t, elements(i).n1.index*2 - 1);
                yja = elements(i).n4.y;
                dyja = D(t, elements(i).n4.index*2);
                yjb = elements(i).n1.y;
                dyjb = D(t, elements(i).n1.index*2);
            end
            line_x = [xja+scale*dxja, xjb+scale*dxjb];
            line_y = [yja+scale*dyja, yjb+scale*dyjb];

            line(line_x,line_y)
        end
    end
    
    pause(0.00001)
end
clear dxja dxjb dyja dyjb i j line_x line_y max_x max_y min_x min_y nx ny offset scale xja xjb yja yjb scale