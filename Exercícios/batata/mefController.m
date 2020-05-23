clear all
close all

filename = "IsoStatic.txt";

run loader.m
run staticPlotter.m
title("Não Deformado")

if dynamic_mode
    run dynamicPreProcessor.m
    run dynamicSolver.m
    run dynamicPlotter.m
else
    run staticPreProcessor.m
    run staticSolver.m
    run staticPlotter.m
    title("Deformado")
end