clear
close all
filename = 'ex_1_din.txt';

run loader.m
run plotter.m
if dynamic_mode
    run dynamicPreProcessor.m
    run dynamicSolver.m
else
    run preProcessor.m
    run solver.m
    run plotter.m
    run postProcessor.m
end

