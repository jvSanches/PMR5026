% Passo 1 - Conectividade
conectivity = zeros(length(elements),4);

for k = 1:length(elements)
    id_x1 = elements(k).n1.id*2 - 1;
    id_y1 = elements(k).n1.id*2;
    id_x2 = elements(k).n2.id*2 - 1;
    id_y2 = elements(k).n2.id*2;
   conectivity(k,:) = [id_x1, id_y1, id_x2, id_y2];
end

% Passo 2 - Matrizes locais
for k = 1:length(elements)
    elements(k) = elements(k).calculateMatrices();
end

% Passo 3 - Matriz global
K = zeros(length(nodes)*2, length(nodes)*2);
for k = 1:length(elements)
   element = elements(k);
   K_elem = element.K_glob;
   
   for i = 1:length(K_elem)
      for j = 1:length(K_elem(1,:)) 
        K(conectivity(k,i), conectivity(k,j)) =  K(conectivity(k,i), conectivity(k,j)) + K_elem(i,j);
      end
   end
end
