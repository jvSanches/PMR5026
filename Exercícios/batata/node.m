classdef node < handle
    %NODE Node for mef
    %   Detailed explanation goes here
    
    properties
        index,
        x,
        y,
        theta,
        fx,
        fy,
        mo,
        dx,
        dy,
        dtheta,
        xconstrained,
        yconstrained,
        thetaconstrained,
        
        
    end
    
    methods
        function obj = node(n_x,n_y)
            %NODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.x = n_x;
            obj.y = n_y;
            obj.theta = 0;
            obj.fx = 0;
            obj.fy = 0;
            obj.mo = 0;
            obj.dx = 0;
            obj.dy = 0;
            obj.xconstrained = 0;
            obj.yconstrained = 0;
            obj.thetaconstrained = 0;
        end
        function setLoad(obj, nfx, nfy, nmo)
            obj.fx = obj.fx + nfx;
            obj.fy = obj.fy + nfy;
            obj.mo = obj.mo + nmo;
        end
        function setIndex(obj, ind)
            obj.index = ind;
        end
            
        function constrain(obj, c_x, c_y, c_theta)
            
            if c_x ~= 'u'
                c_x = str2num(c_x);
                obj.xconstrained = 1;
                obj.dx = c_x;
            end
            if c_y ~= 'u'
                c_y = str2num(c_y);
                obj.yconstrained = 1;
                obj.dy = c_y;
            end
            if c_theta ~= 'u'
                c_theta = str2num(c_theta);
                obj.thetaconstrained = 1;
                obj.dtheta = c_theta;
            end
        end
        function setDeltas(obj, ndx, ndy)
            obj.dx = ndx;
            obj.dy = ndy;
        end
    end
end

