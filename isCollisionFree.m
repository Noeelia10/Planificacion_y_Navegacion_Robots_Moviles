function free = isCollisionFree(map, p1, p2)
    N = 200;  
    % Generación de N puntos entre p1 y p2
    x = linspace(p1(1), p2(1), N);
    y = linspace(p1(2), p2(2), N);
    [rows, cols] = size(map);

    free = true;

    % Para cada punto intermedio entre p1 y p2, se redondea a celda de la
    % matriz
    for i = 1:N
        xi = floor(x(i)) + 1;
        yi = floor(y(i)) + 1;
        % Comprobación de límites (están dentro del mapa)
        if xi < 1 || xi > cols || yi < 1 || yi > rows
            free = false;
            return;
        end
        % Obstáculo detectado
        if map(yi, xi) == 1
            free = false;
            return;
        end
    end
end

