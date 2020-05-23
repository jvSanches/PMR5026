%function mefController(filename)
    close all
    
%     if nargin < 1
%         filename = "Isoparam_0.txt";
%     end
    filename = "Isoparam_0.txt";
    
    run loader.m
    run isoPlotter.m
   
    if dynamic_mode
        run dynamicPreProcessor.m
        run dynamicSolver.m
        %run dynamicPlotter.m
    else
        run preProcessor.m
        run solver.m
        run isoPlotter.m
        %run plotter.m
%         run postProcessor.m
    end
%end