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
        M,
        ro,
        
        
    end
    
    methods
        function obj = truss(node1, node2, area, e_modulus, density)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.n1 = node1;
            obj.n2 = node2;
            obj.A = area;
            obj.E = e_modulus;
            obj.ro = density;
            obj.L = sqrt((node2.x - node1.x)^2 + (node2.y - node1.y)^2);
            l = (node2.x-node1.x) / obj.L;
            m = (node2.y-node1.y) / obj.L;   
            obj.K = (obj.E*obj.A/obj.L)*[l*l l*m 0 -l*l -l*m 0;
                                         l*m m*m 0 -l*m -m*m 0;
                                         0 0 1 0 0 0;
                                        -l*l -l*m 0 l*l l*m 0;
                                         -l*m -m*m 0 l*m m*m 0;
                                         0 0 0 0 0 1];
            obj.M = (obj.A * obj.ro * obj.L/6)*[2*l*l 2*l*m l*l l*m;
                                                2*l*m 2*m*m l*m m*m;
                                                l*l l*m 2*l*l 2*l*m;
                                                l*m m*m 2*l*m 2*m*m];
                            
        end
        
        function [k11, k12, k22, index1, index2] = decomposeStiffnes(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            k11 = obj.K(1:3,1:3);
            k12 = obj.K(1:3,4:6);
            k22 = obj.K(4:6,4:6);
            index1 = obj.n1.index;
            index2 = obj.n2.index;
        end
        function [m11, m12, m22, index1, index2] = decomposeMass(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            m11 = obj.M(1:2,1:2);
            m12 = obj.M(1:2,3:4);
            m22 = obj.M(3:4,3:4);
            index1 = obj.n1.index;
            index2 = obj.n2.index;
        end
        function tension = getTension(obj)
            nx1 = obj.n1.x+obj.n1.dx;
            ny1 = obj.n1.y+obj.n1.dy;
            nx2 = obj.n2.x+obj.n2.dx;
            ny2 = obj.n2.y+obj.n2.dy;
            L_strain = sqrt((nx2 - nx1)^2 + (ny2 - ny1)^2);
            tension = (obj.L-L_strain)/obj.L * obj.E;
        end
    end
end

