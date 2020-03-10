classdef truss
    %UNTITLED truss element
    %   Detailed explanation goes here
    
    properties
        id,
        n1,
        n2,
        A,
        E,
        L,
        K_glob,
        T,
    end
    
    methods
        function obj = truss(id, node1, node2, area, e_modulus)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id;
            obj.n1 = node1;
            obj.n2 = node2;
            obj.L = sqrt((obj.n1.x - obj.n2.x)^2 + (obj.n1.y - obj.n2.y)^2);
            obj.A = area;
            obj.E = e_modulus;
        end
        
        function obj = calculateMatrices(obj)
            l = (obj.n2.x - obj.n1.x)/obj.L;
            m = (obj.n2.y - obj.n1.y)/obj.L;
            obj.T = [ l  m  0  0;
                     -m  l  0  0;
                      0  0  l  m;
                      0  0 -m  l];
            K_loc = ((obj.E*obj.A)/obj.L)*[1 0 -1 0; 0 0 0 0; -1 0 1 0; 0 0 0 0];
            obj.K_glob = (obj.T^-1)*K_loc*obj.T;
        end
    end
end

