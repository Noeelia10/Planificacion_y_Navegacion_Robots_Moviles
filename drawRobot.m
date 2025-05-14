function drawRobot(x, y, theta, color)
    % Parámetros geométricos del robot (puedes ajustar)
    L = 1.0;  % Largo desde eje trasero hasta punta (vértice A)
    W = 0.6;  % Ancho entre ruedas traseras (vértices B y C)

    % Coordenadas locales del triángulo (A, B, C)
    pts_local = [ L,   0;   % Punto A (punta del triángulo, adelante)
                 -L/2, -W/2; % Punto B (rueda izquierda)
                 -L/2,  W/2];% Punto C (rueda derecha)

    % Matriz de rotación
    R = [cos(theta), -sin(theta);
         sin(theta),  cos(theta)];

    % Transformar puntos a coordenadas globales
    pts_global = (R * pts_local')' + [x, y];

    % Dibujar triángulo del robot
    fill(pts_global(:,1), pts_global(:,2), color, 'EdgeColor', 'k');
end
