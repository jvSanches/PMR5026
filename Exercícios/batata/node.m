classdef node < handle
    %NODE Node for mef
    %   Detailed explanation goes here
    
    properties
        index,
        x,
        y,
        fx,
        fy,
        dx,
        dy,
        xconstrained,
        yconstrained,
        
        
    end
    
    methods
        function obj = node(n_x,n_y)
            %NODE Construct an instance of this class
            %   Detailed explanation goes here
            obj.x = n_x;
            obj.y = n_y;
            obj.fx = 0;
            obj.fy = 0;
            obj.dx = 0;
            obj.dy = 0;
            obj.xconstrained = 0;
            obj.yconstrained = 0;
        end
        function setLoad(obj, nfx, nfy)
            obj.fx = nfx;
            obj.fy = nfy;
        end
        function setIndex(obj, ind)
            obj.index = ind;
        end
            
        function constrain(obj, c_x, c_y)
            if c_x ~= 'u'
                obj.xconstrained = 1;
                obj.dx = c_x;
            end
            if c_y ~= 'u'
                obj.yconstrained = 1;
                obj.dy = c_y;
            end
        end
        function setDeltas(obj, ndx, ndy)
            obj.dx = ndx;
            obj.dy = ndy;
        end
    end
end

