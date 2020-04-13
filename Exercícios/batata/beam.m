classdef beam
    %UNTITLED beam element
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
        T,
        ro,
        I,
        Px = 0,
        Py = 0,
        elasticLineX,
        elasticLineY,
        Normal,
        Shear,
        Moment    
    end
    
    methods
        function obj = beam(node1, node2, area, e_modulus, i_moment, density)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.n1 = node1;
            obj.n2 = node2;
            obj.A = area;
            obj.E = e_modulus;
            obj.ro = density;
            obj.L = sqrt((node2.x - node1.x)^2 + (node2.y - node1.y)^2);
            obj.I = i_moment;
            l = (node2.x-node1.x) / obj.L;
            m = (node2.y-node1.y) / obj.L;
            obj.l = l;
            obj.m = m;
            A = obj.A;
            E = obj.E;
            L = obj.L;
            I = obj.I;
            K = [A*E/L 0 0 -A*E/L 0 0;
                0 12*E*I/L^3 6*E*I/L^2 0 -12*E*I/L^3 6*E*I/L^2;
                0 6*E*I/L^2 4*E*I/L 0 -6*E*I/L^2 2*E*I/L;
                -A*E/L 0 0 A*E/L 0 0;
                0 -12*E*I/L^3 -6*E*I/L^2 0 12*E*I/L^3 -6*E*I/L^2;
                0 6*E*I/L^2 2*E*I/L 0 -6*E*I/L^2 4*E*I/L];
            T = [l m 0 0 0 0;
                 -m l 0 0 0 0;
                 0 0 1 0 0 0;
                 0 0 0 l m 0;
                 0 0 0 -m l 0;
                 0 0 0 0 0 1];
            obj.T = T;
             
            obj.K = T\K * T;
                                
            M = (obj.ro * obj.A * obj.L / 420) * [140 0 0 70 0 0;
                0 156 22*L 0 54 -13*L;
                0 22*L 4*L^2 0 13*L -3*L^2;
                70 0 0 140 0 0;
                0 54 13*L 0 156 -22*L;
                0 -13*L -3*L^2 0 -22*L 4*L^2];
            obj.M = T\M * T;
                            
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
            m11 = obj.M(1:3,1:3);
            m12 = obj.M(1:3,4:6);
            m22 = obj.M(4:6,4:6);
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

        function setPressure(obj, npx, npy)
            obj.Px = npx;
            obj.Py = npy;
            nmo1 = (npx+npy) * obj.L^2 / 2; 
            obj.n1.setLoad(obj.L * npx/2, obj.L * npy/2,0);
            obj.n2.setLoad(obj.L * npx/2, obj.L *  npy/2,0 );
        end
            
        function obj = calculateStress(obj)
            syms x
            u = obj.T * [obj.n1.dx; obj.n1.dy; obj.n1.dtheta; obj.n2.dx; obj.n2.dy; obj.n2.dtheta];
            
            obj.elasticLineX = u(1) + (1 + (u(4) - u(1))/obj.L)*x + 1e-20*x;
            obj.Normal = obj.E*obj.A*(u(4) - u(1))/obj.L + 1e-20*x;
            
            E = obj.E; I = obj.I; L = obj.L;
            load = obj.Py;

            w0 = u(2);
            wL = u(5);
            phi0 = u(3);
            phiL = u(6);

            obj.elasticLineY = w0 + phi0*x + ((5*L^4*load - 360*E*I*w0 + 360*E*I*wL - 240*E*I*L*phi0 - 120*E*I*L*phiL) / (120*E*I*L^2))*x^2 + (-(10*L^4*load - 240*E*I*w0 + 240*E*I*wL - 120*E*I*L*phi0 - 120*E*I*L*phiL) / (120*E*I*L^3))*x^3 + (load / (24*E*I))*x^4;
            obj.Moment = E*I*diff(obj.elasticLineY,2) + 1e-20*x;
            obj.Shear = diff(obj.Moment) + 1e-20*x;
            
        end
    end
end

