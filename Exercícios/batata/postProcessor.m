disp("Showing results...");

for i=1:length(elements)
    tension = elements(i).getTension;
    disp("Stress on element " + string(i) + " is " + string(tension/1000000) + " MPa")
end
    