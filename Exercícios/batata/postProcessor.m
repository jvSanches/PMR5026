disp("Showing results...");
for i=1:length(nodes)
    dx = nodes(i).dx;
    dy = nodes(i).dy;
    disp("Displacement on node " + string(i) + " is " + string(dx) + " in x and " + string(dy) + " in y")
end
% 
% for i=1:length(elements)
%     tension = elements(i).getTension;
%     disp("Stress on element " + string(i) + " is " + string(tension/1000000) + " MPa")
% end
%     