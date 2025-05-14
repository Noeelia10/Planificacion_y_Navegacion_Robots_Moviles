function [nodes, edges] = buildPRM_fixed(map, num_samples, k, start_pos, goal_pos)
    [rows, cols] = size(map); % Tamaño del mapa (filas y columnas)
    nodes = [];

    % 1. Obtener todas las celdas libres (para asegurar validez)
    freeCells = find(map == 0); % Encuentra los índices libres en el mapa
    [freeY, freeX] = ind2sub(size(map), freeCells); 

    % 2. Generar nodos aleatorios en el centro de celdas libres
    while size(nodes, 1) < num_samples
        idx = randi(length(freeX)); % Selecciona una celda libre aleatoria
        % Ajusta en el centro de la celda
        x = freeX(idx) - 0.5;
        y = freeY(idx) - 0.5;
        nodes(end+1, :) = [x, y];
    end

    % 3. Incluir explícitamente los nodos de inicio y fin
    nodes = [start_pos; goal_pos; nodes];

    % 4. Conectar nodos con sus k vecinos más cercanos evitando colisiones
    edges = []; % Lista de aristas = uniones entre nodos
    num_nodes = size(nodes, 1);
    for i = 1:num_nodes
        distances = vecnorm(nodes - nodes(i,:), 2, 2); % Calcula distancias a todos los nodos
        [~, idxs] = sort(distances); % Las ordena en función de la distancia
        count = 0;
        j = 2;
        while count < k && j <= num_nodes
            n1 = nodes(i,:);
            n2 = nodes(idxs(j),:);
            if isCollisionFree(map, n1, n2) % Si no atraviesa obstáculos
                edges(end+1,:) = [i, idxs(j)]; % Añade arista
                plot([n1(1), n2(1)], [n1(2), n2(2)], 'k-');
                count = count + 1;
            end
            j = j + 1;
        end
    end

    % 5. Dibujar nodos
    scatter(nodes(:,1), nodes(:,2), 30, [1, 0.5, 0], 'filled'); % Naranja
end

