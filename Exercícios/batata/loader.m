clear 
filename = 'Entrada_ex3.txt';
%% Open and read the file

fid = fopen(filename);
Text = textscan(fid,'%s','delimiter','\n');
Text = Text{1};
fclose(fid);

%% Read Header
header_lines =[];
for i = 1:length(Text)
   if strcmp(Text{i},'#HEADER')
       while (1)
           a = sscanf(string(Text(i+1)), '%10c');
           if isempty(a)
               break;
           else               
               header_lines = [header_lines a newline];
               i = i+1;
           end
       end
   end
end

%% Read mode
dynamic_mode =0;
for i = 1:length(Text)
   if strcmp(Text{i},'#DYNAMIC')
       a = sscanf(string(Text(i+1)), '%i');
       if isempty(a)
           break;
       else
           if a==1
               dynamic_mode = 1;
           end
       end
    end
end

%% Read timestep

if dynamic_mode
    timestep =0;
    for i = 1:length(Text)
       if strcmp(Text{i},'#TIMESTEP')
           a = sscanf(string(Text(i+1)), '%f');
           if isempty(a)
               break;
           else
               timestep = a;

           end
        end
    end
    simtime = 0;
    for i = 1:length(Text)
       if strcmp(Text{i},'#SIMTIME')
           a = sscanf(string(Text(i+1)), '%f');
           if isempty(a)
               break;
           else
               simtime = a;

           end
        end
    end
    
end

%% Read nodes
nodes = [];
for i = 1:length(Text)
   if strcmp(Text{i},'#NODES')
       j=1;
       while (1)
           a = sscanf(string(Text(i+j)), '%f %f', [1 2]);
           if isempty(a)
               break;
           else
               new_node = node(a(1), a(2));
               new_node.setIndex(j);
               nodes = [nodes new_node];
               j = j+1;
           end
       end
   end
end


%% Read elements 
elements = [];
for i = 1:length(Text)
   if strcmp(Text{i},'#ELEMENTS')
       while (1)
           a = sscanf(string(Text(i+1)), '%f %f %f %f %f', [1 5]);
           if isempty(a)
               break;
           else
               new_element = truss(nodes(a(1)), nodes(a(2)), a(3), a(4), a(5));
               elements = [elements new_element];
               i = i+1;
           end
       end
   end
end

%% Read Loads
for i = 1:length(Text)
   if strcmp(Text{i},'#LOADS')
       reading_load_on_node = 0;
       part_load_data = [];
       j=1;
       while (1)
           a = sscanf(string(Text(i+j)), '%s');
           if isempty(a)               
               if reading_load_on_node
                       nodes(reading_load_on_node).setLoad(part_load_data(:,1),part_load_data(:,2));
               end 
               break;
           else               
               if a(1)=='@'
                   
                   if reading_load_on_node
                       nodes(reading_load_on_node).setLoad(part_load_data(:,1),part_load_data(:,2));
                   end                   
                   reading_load_on_node = str2num(a(2:end));
               else
                   a = sscanf(string(Text(i+j)), '%f %f', [1 2]);
                   part_load_data = [part_load_data ; a];
               end
           end
           j = j+1;
           
       end
       
   end
end

%% Read Constrains
for i = 1:length(Text)
   if strcmp(Text{i},'#CONSTRAINTS')
       reading_constrain_on_node = 0;
       part_constrain_data = [];
       j=1;
       while (1)
           
           a = sscanf(string(Text(i+j)), '%s');
           if isempty(a)               
               if reading_constrain_on_node
                       nodes(reading_constrain_on_node).constrain(part_constrain_data(:,1),part_constrain_data(:,2));
                       part_constrain_data = [];
               end 
               break;
           else               
               if a(1)=='@'
                   
                   if reading_constrain_on_node
                       nodes(reading_constrain_on_node).constrain(part_constrain_data(:,1),part_constrain_data(:,2));
                       part_constrain_data = [];
                   end                   
                   reading_constrain_on_node = str2num(a(2:end));
               else
                   a = sscanf(string(Text(i+j)), '%f %f', [1 2]);
                   part_constrain_data = [part_constrain_data ; a];
               end
           end
           j = j+1;
           
       end
       
   end
end

%% Display loaded info
clc
disp([filename ' loaded'])
disp('----------------------------------------------------')
disp(header_lines)
disp('----------------------------------------------------')
disp([num2str(length(nodes)) ' nodes ' ])
disp([num2str(length(elements)) ' elements ' ])
disp('Loading Done');


