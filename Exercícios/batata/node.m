classdef node < handle
    %NODE Node for mef
    %   Detailed explanation goes here
    
    properties
        id,
        x,
        y,
        fx,
        fy,
        cx,
        cy,
        constrained;
    end
    
    methods
        function obj = node(id, n_x, n_y)
            %NODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.id = id;
            obj.x = n_x;
            obj.y = n_y;
            obj.fx = 0;
            obj.fy = 0;
            obj.constrained = 0;
        end
        function setLoad(obj, nfx, nfy)
            obj.fx = nfx;
            obj.fy = nfy;
        end
            
        function constrain(obj, c_x, c_y)
            obj.constrained = 1;
            obj.cx = c_x;
            obj.cy = c_y;
        end
    end
end

