clear all
close all
%filename = 'ex_2_din_ponte.txt';
filename = 'teste_vigas.txt';
%filename = 'vig2.txt';
%filename = 'ex_vigas_2.txt';

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

