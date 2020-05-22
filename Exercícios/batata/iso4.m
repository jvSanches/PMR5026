classdef iso4 < handle
    %UNTITLED beam element
    %   Detailed explanation goes here
    
    properties
        n1,
        n2,
        n3,
        n4,
        E,
        T,
        K,
        M,
        ro,
        mu,
        
    end
    
    methods
        function obj = iso4(node1, node2, node3, node4, thickness, e_modulus, poisson ,density, plane_stress)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.n1 = node1;
            obj.n2 = node2;
            obj.n3 = node3;
            obj.n4 = node4;
            obj.E = e_modulus;
            obj.T = thickness;
            obj.ro = density;
            obj.mu = poisson;
            
            %%
            J = zeros(2);
            Be = zeros(3,8);
            Ke = zeros(8);
            mu = poisson;
            
            if plane_stress
            %%plane stress
                C = 1/(1-mu^2) * [1 mu 0
                                  mu 1 0
                                  0 0 (1-mu)/2];
            else
            %%plane strain
                C = 1/(1+mu)*(1-2*mu) * [1-mu mu 0
                                        mu 1-mu 0
                                        0 0 (1-2*mu)/2];
            end
            
            for i=1:4
                if i==1 
                    r=-0.577350269;s= r;
                elseif i==2 
                    r=-0.577350269;s=-r;
                elseif i==3 
                    r= 0.577350269;s= r;
                elseif i==4 
                    r= 0.577350269;s=-r;
                end

                N1r=-(1-s)/4; 
                N2r=(1-s)/4;
                N3r=(1+s)/4; 
                N4r=-(1+s)/4;
                N1s=-(1-r)/4; 
                N2s=-(1+r)/4;
                N3s=(1+r)/4; 
                N4s=(1-r)/4;
%                 J(1,1)=N1r*x1+N2r*x2+N3r*x3+N4r*x4;
%                 J(1,2)=N1r*y1+N2r*y2+N3r*y3+N4r*y4;
%                 J(2,1)=N1s*x1+N2s*x2+N3s*x3+N4s*x4;
%                 J(2,2)=N1s*y1+N2s*y2+N3s*y3+N4s*y4;
                
                J(1,1)=N1r*node1.x+N2r*node2.x+N3r*node3.x+N4r*node4.x;
                J(1,2)=N1r*node1.y+N2r*node2.y+N3r*node3.y+N4r*node4.y;
                J(2,1)=N1s*node1.x+N2s*node2.x+N3s*node3.x+N4s*node4.x;
                J(2,2)=N1s*node1.y+N2s*node2.y+N3s*node3.y+N4s*node4.y;
                
                Jinv=inv(J);
                N1x=Jinv(1,1)*N1r+Jinv(1,2)*N1s;
                N2x=Jinv(1,1)*N2r+Jinv(1,2)*N2s;
                N3x=Jinv(1,1)*N3r+Jinv(1,2)*N3s;
                N4x=Jinv(1,1)*N4r+Jinv(1,2)*N4s;
                N1y=Jinv(2,1)*N1r+Jinv(2,2)*N1s;
                N2y=Jinv(2,1)*N2r+Jinv(2,2)*N2s;
                N3y=Jinv(2,1)*N3r+Jinv(2,2)*N3s;
                N4y=Jinv(2,1)*N4r+Jinv(2,2)*N4s;
                B=[N1x 0 N2x 0 N3x 0 N4x 0 ;
                0 N1y 0 N2y 0 N3y 0 N4y ;
                N1y N1x N2y N2x N3y N3x N4y N4x];
                Be=B+Be;
                Ke=Be'*C*Be*e_modulus*thickness*det(J)+Ke;
                obj.K = Ke;
            
            end
            
                            
        end
        
        function [K, index1, index2, index3, index4] = decomposeStiffnes(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            K=obj.K;
            index1 = obj.n1.index;
            index2 = obj.n2.index;
            index3 = obj.n3.index;
            index4 = obj.n4.index;
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

        function obj = setPressure(obj, npx, npy)
            obj.Px = npx;
            obj.Py = npy;
            nmo1 = (npy) * obj.L^2 / 12; 
            obj.n1.setLoad(obj.L * npx/2, obj.L * npy/2, nmo1);
            obj.n2.setLoad(obj.L * npx/2, obj.L *  npy/2, -nmo1);
        end
            
        function obj = calculateStress(obj)
            syms x
            u = obj.T * [obj.n1.dx; obj.n1.dy; obj.n1.dtheta; obj.n2.dx; obj.n2.dy; obj.n2.dtheta];
            
            obj.elasticLineX = u(1) + (1 + (u(4) - u(1))/obj.L)*x;
            obj.Normal = obj.E*obj.A*(u(4) - u(1))/obj.L;
            
            E = obj.E; I = obj.I; L = obj.L;
            load = obj.Py;

            w0 = u(2);
            wL = u(5);
            phi0 = u(3);
            phiL = u(6);

            obj.elasticLineY = w0 + phi0*x + ((5*L^4*load - 360*E*I*w0 + 360*E*I*wL - 240*E*I*L*phi0 - 120*E*I*L*phiL) / (120*E*I*L^2))*x^2 + (-(10*L^4*load - 240*E*I*w0 + 240*E*I*wL - 120*E*I*L*phi0 - 120*E*I*L*phiL) / (120*E*I*L^3))*x^3 + (load / (24*E*I))*x^4;
            obj.Moment = E*I*diff(obj.elasticLineY,2);
            obj.Shear = diff(obj.Moment);
            
        end
    end
end

