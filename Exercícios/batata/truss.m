classdef truss
    %UNTITLED truss element
    %   Detailed explanation goes here
    
    properties
        n1,
        n2,
        A,
        E
    end
    
    methods
        function obj = truss(node1, node2, area, e_modulus)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.n1 = node1;
            obj.n2 = node2;
            obj.A = area;
            obj.E = e_modulus;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

