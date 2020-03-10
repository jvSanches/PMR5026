classdef truss
    %UNTITLED truss element
    %   Detailed explanation goes here
    
    properties
        n1,
        n2,
        A,
        E,
        L,
        m,
        l,
        K,
        
        
    end
    
    methods
        function obj = truss(node1, node2, area, e_modulus)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.n1 = node1;
            obj.n2 = node2;
            obj.A = area;
            obj.E = e_modulus;
            obj.L = sqrt((node2.x - node1.x)^2 + (node2.y - node1.y)^2);
            l = (node2.x-node1.x) / obj.L;
            m = (node2.y-node1.y) / obj.L;   
            obj.K = (obj.E*obj.A/obj.L)*[l*l l*m -l*l -l*m;
                             l*m m*m -l*m -m*m;
                             -l*l -l*m l*l -m*m;
                             -l*m -m*m l*m m*m];
                            
        end
        
        function [k11, k12, k22, index1, index2] = decomposeToGlobal(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            k11 = obj.K(1:2,1:2);
            k12 = obj.K(1:2,3:4);
            k22 = obj.K(3:4,3:4);
            index1 = obj.n1.index;
            index2 = obj.n2.index;
        end
    end
end

