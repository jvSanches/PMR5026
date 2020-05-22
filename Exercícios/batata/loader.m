%% Open and read the file
disp("Reading file")

fid = fopen(filename);
Text = textscan(fid,'%s','delimiter','\n');
Text = Text{1};
fclose(fid);

disp("Interpreting file")

header_lines =[];
dynamic_mode = 0;
modal_analysis = 0;
nodes = [];
elements = [];

reading_load_on_node = 0;
reading_load_on_element = 0;
reading_constrain_on_node = 0;
reading_disp_on_node = 0;
reading_vel_on_node = 0;
reading_acc_on_node = 0;
part_load_data = [];

initial_disp = [];
initial_vel = [];
initial_acc = [];

state = "";
for i = 1:length(Text)
    line = Text{i};
    
    if isempty(line)
        if reading_load_on_node
            nodes(reading_load_on_node).setLoad(part_load_data(:,1),part_load_data(:,2),part_load_data(:,3));
            reading_load_on_node = 0;
        end 
        if reading_load_on_element
            elements(reading_load_on_element).setPressure(part_load_data(:,1),part_load_data(:,2));
            reading_load_on_element = 0;
        end
        if reading_constrain_on_node
            nodes(reading_constrain_on_node).constrain(constrain_data(1),constrain_data(2),constrain_data(3));
            reading_constrain_on_node = 0;
        end
        if reading_disp_on_node
            initial_disp(:,reading_disp_on_node) = transpose(disp_data);
            reading_disp_on_node = 0;
        end
        if reading_vel_on_node
            initial_vel(:,reading_vel_on_node) = transpose(disp_data);
            reading_vel_on_node = 0;
        end
        if reading_acc_on_node
            initial_acc(:,reading_acc_on_node) = transpose(disp_data);
            reading_acc_on_node = 0;
        end
        state = "";
        continue;
    elseif line(1) == "#"
        state = line;
        continue;
    end

    
    switch state
        case "#HEADER"
            header_lines = [header_lines line newline];
        case "#DYNAMIC"
            dynamic_mode = sscanf(line, '%i') == 1;
            timestep = 0;
            simtime = 0;
        case "#MODAL"
            modal_analysis = sscanf(line, '%i') == 1;
        case '#TIMESTEP'
            timestep = sscanf(line, '%f');
        case '#SIMTIME'
            simtime = sscanf(line, '%f');
        case '#NODES'
            a = sscanf(line, '%f %f', [1 2]);
            new_node = node(a(1), a(2));
            nodes = [nodes new_node];
            new_node.setIndex(length(nodes));
        case '#ELEMENTS'
            a = sscanf(line, '%s %f %f %f %f %f %f %f %f ', [1 9]);
            if a(1) == 't'
                new_element = truss(nodes(a(2)), nodes(a(3)), a(4), a(5), a(6));
            elseif a(1) == 'b'
                new_element = beam(nodes(a(2)), nodes(a(3)), a(4), a(5), a(6), a(7));
            elseif a(1) == 'i'
                new_element = iso4(nodes(a(2)), nodes(a(3)), nodes(a(4)), nodes(a(5)),a(6), a(7),a(8), a(9));
            end
            elements = [elements new_element];
        case '#LOADS'
            if a(1)=='@'            
                if reading_load_on_node
                    nodes(reading_load_on_node).setLoad(part_load_data(:,1),part_load_data(:,2),part_load_data(:,3));
                end                   
                reading_load_on_node = str2num(a(2:end));
            else
                a = sscanf(line, '%f %f %f', [1 3]);
                part_load_data = [part_load_data ; a];
            end
        case '#PRESSURES'
            if line(1)=='@'
                if reading_load_on_element
                    elements(reading_load_on_element).setPressure(part_load_data(:,1),part_load_data(:,2));
                end                   
                reading_load_on_element = str2num(line(2:end));
            else
                a = sscanf(line, '%f %f %f', [1 3]);
                part_load_data = [part_load_data ; a];
            end
        case '#CONSTRAINTS'
            if line(1)=='@'
                if reading_constrain_on_node
                   nodes(reading_constrain_on_node).constrain(constrain_data(1),constrain_data(2),constrain_data(3));
                end
                reading_constrain_on_node = str2num(line(2:end));
            else
                constrain_data = sscanf(line, '%s %s %s', [1 3]);
            end
        case '#INITIALDISP'
            if initial_disp.isempty
                initial_disp = zeros(2,length(nodes));
            end
            if line(1)=='@'
                if reading_disp_on_node
                   initial_disp(:,reading_disp_on_node) = transpose(disp_data);
                end
                reading_disp_on_node = str2num(line(2:end));
            else
                disp_data = sscanf(line, '%s %s %s', [1 3]);
            end
        case '#INITIALVEL'
            if initial_vel.isempty
                initial_vel = zeros(2,length(nodes));
            end
            if line(1)=='@'
                if reading_vel_on_node
                   initial_vel(:,reading_vel_on_node) = transpose(vel_data);
                end
                reading_vel_on_node = str2num(line(2:end));
            else
                vel_data = sscanf(line, '%s %s %s', [1 3]);
            end
        case '#INITIALACCEL'
            if initial_acc.isempty
                initial_acc = zeros(2,length(nodes));
            end
            if line(1)=='@'
                if reading_acc_on_node
                   initial_acc(:,reading_acc_on_node) = transpose(acc_data);
                end
                reading_acc_on_node = str2num(line(2:end));
            else
                disp_acc = sscanf(line, '%s %s %s', [1 3]);
            end
    end
end

%% Display loaded info
%clc
disp([filename ' loaded'])
disp('----------------------------------------------------')
disp(header_lines)
disp('----------------------------------------------------')
disp([num2str(length(nodes)) ' nodes ' ])
disp([num2str(length(elements)) ' elements ' ])
disp('Loading Done');

%% Clear workspace
clear ans a fid filename header_lines i j new_element new_node part_load_data reading_load_on_element reading_load_on_node reading_on_node Text line

