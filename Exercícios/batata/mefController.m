clear
close all
filename = 'ex_2_din_ponte.txt';

run loader.m
run plotter.m
if dynamic_mode
    run dynamicPreProcessor.m
    %run dynamicSolver.m
else
    run preProcessor.m
    run solver.m
    run plotter.m
    run postProcessor.m
end

