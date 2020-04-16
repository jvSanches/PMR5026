function mefController(filename)
    close all
    
    if nargin < 1
        filename = "balanco_modal_1.txt";
    end
    
    run loader.m
    %run plotter.m
    if dynamic_mode
        run dynamicPreProcessor.m
        run dynamicSolver.m
        %run dynamicPlotter.m
    else
        run preProcessor.m
        run solver.m
        %run plotter.m
        run postProcessor.m
    end
end