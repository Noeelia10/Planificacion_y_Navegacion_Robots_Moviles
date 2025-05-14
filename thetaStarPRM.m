%% Algoritmo Theta*
function path = thetaStarPRM(nodes, edges, start_idx, goal_idx, map)
    N = size(nodes, 1);
    
    g = inf(N, 1);
    f = inf(N, 1);
    parent = zeros(N, 1);
    closed = false(N, 1);
    open = containers.Map('KeyType', 'int32', 'ValueType', 'double');

    g(start_idx) = 0;
    f(start_idx) = heuristic(nodes(start_idx,:), nodes(goal_idx,:));
    parent(start_idx) = start_idx;
    open(start_idx) = f(start_idx);

    while ~isempty(open)
        open_keys = cell2mat(keys(open));
        open_vals = cell2mat(values(open));
        [~, idx_min] = min(open_vals);
        current = open_keys(idx_min);

        if current == goal_idx
            break;
        end

        remove(open, current);
        closed(current) = true;

        % Obtener vecinos conectados
        neighbors = edges(any(edges == current, 2), :);
        neighbors = unique(neighbors(:));
        neighbors(neighbors == current) = [];

        for i = 1:length(neighbors)
            s = neighbors(i);
            if closed(s)
                continue;
            end

            % El truco de Theta*: intentar conectar al abuelo si hay visibilidad
            if isCollisionFree(map, nodes(parent(current),:), nodes(s,:))
                % Conectar al padre del current
                tentative_g = g(parent(current)) + heuristic(nodes(parent(current),:), nodes(s,:)); % Calcula el coste total de ir desde el inicio hasta el punto s pasando por el abuelo
                % Solo actualiza el nodo s si este nuevo camino directo es
                % mejor que el actual
                if tentative_g < g(s)
                    g(s) = tentative_g;
                    parent(s) = parent(current);
                    f(s) = g(s) + heuristic(nodes(s,:), nodes(goal_idx,:));
                    open(s) = f(s);
                end
            else
                % Si no hay visibilidad directa, actua como A*
                tentative_g = g(current) + heuristic(nodes(current,:), nodes(s,:));
                if tentative_g < g(s)
                    g(s) = tentative_g;
                    parent(s) = current;
                    f(s) = g(s) + heuristic(nodes(s,:), nodes(goal_idx,:));
                    open(s) = f(s);
                end
            end
        end
    end

    % Reconstrucción del camino
    path = goal_idx;
    while path(1) ~= start_idx
        path = [parent(path(1)); path];
    end
end