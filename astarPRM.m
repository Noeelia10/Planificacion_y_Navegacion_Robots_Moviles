%% Algoritmo A*
function path = astarPRM(nodes, edges, start_idx, goal_idx)

    N = size(nodes, 1);
    
    % Inicializar listas
    open = containers.Map('KeyType', 'int32', 'ValueType', 'double'); % Lista de nodos por explorar
    closed = false(N, 1); % Nodos ya explorados
    g = inf(N, 1); % Coste desde el inicio a cada nodo g(n)
    f = inf(N, 1); % Coste total estimado f(n) = g(n) + h(n)
    parent = zeros(N, 1); % Reconstruir el camino
    
    g(start_idx) = 0; % Coste inicial = 0
    f(start_idx) = norm(nodes(start_idx,:) - nodes(goal_idx,:)); % Distancia euclídea
    open(start_idx) = f(start_idx);
    
    while ~isempty(open)
        % Obtener la clave del nodo con menor f(n)
        open_keys = cell2mat(keys(open));
        open_vals = cell2mat(values(open));

        [~, idx_min] = min(open_vals); % Busca el nodo con menor coste total f(n)
        current = open_keys(idx_min); 


        if current == goal_idx
            break; % Si llegamos al destino, salimos del bucle
        end

        remove(open, current); 
        closed(current) = true;

        % Vecinos: buscar en edges
        neighbors = edges(any(edges == current, 2), :); % Buscamos todas las aristas conectadas
        neighbors = unique(neighbors(:)); % Obtenemos nodos vecinos
        neighbors(neighbors == current) = []; 

        for i = 1:length(neighbors)
            neighbor = neighbors(i); 
            if closed(neighbor) 
                continue; % Si ya se ha explorado, lo ignoramos
            end

            cost = norm(nodes(current,:) - nodes(neighbor,:)); % Coste real vecino
            tentative_g = g(current) + cost; % Coste tentativo desde el inicio

            if tentative_g < g(neighbor)
                g(neighbor) = tentative_g;
                f(neighbor) = g(neighbor) + norm(nodes(neighbor,:) - nodes(goal_idx,:)); % Nuevo f(n)
                parent(neighbor) = current;
                open(neighbor) = f(neighbor); % Añadir o actualizar en la lista abierta
            end
        end
    end

    % Reconstruir el camino
    path = goal_idx;
    while path(1) ~= start_idx
        path = [parent(path(1)); path];
    end
end
