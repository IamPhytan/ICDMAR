
% Lecture du fichier de configuration
fileID = fopen("./config.txt", 'r');
contents = textscan(fileID, '%f %f %f\r\n', 'HeaderLines', 11);
fclose(fileID);

% Vérifie si toutes les colonnes ont le même nombre de valeurs
num_colonnes = numel(contents);
if num_colonnes ~= 3
    warning("Une ligne du fichier de configuration a trop de données")
end

num_elems = zeros(1, num_colonnes);
for i=1:numel(contents)
    num_elems(i) = sum(~isnan(contents{i}));
end

if ~(range(num_elems) == 0)
    [~, I] = min(num_elems);
    switch I
        case 1
            nom_colu = "de longueur";
        case 2
            nom_colu = "de largeur";
        case 3
            nom_colu = "d'angle";
    end
    ME = MException('MATLAB:missingValue', ...
        'Il manque des valeurs %s dans le fichier de configuration', nom_colu);
    throw(ME)
end

% Nombre de membres
n = numel(contents{1});

% Origine du tracé
values.('x') = 0;
values.('y') = 0;

% Création de la figure et maintien du tracé
figure
grid on
hold on

for i=1:n
    % Paramètres
    long = contents{1}(i);
    larg = contents{2}(i);
    ang = contents{3}(i);
    
    fin_pnts = tracer_membre(i, values.('x')(end), values.('y')(end), long, larg, ang);
    values.('x') = [values.('x'), fin_pnts(1)];
    values.('y') = [values.('y'), fin_pnts(2)];

end

% AXES

% Fonction pour dessiner des flèches
drawArrow = @(x,y, varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );

% Valeurs minimales des axes
ax_x_max = round(max(values.('x')), -1) + 5;
ax_y_max = round(max(values.('y')), -1) + 5;

% % Valeurs maximales des axes
ax_x_min = round(min(values.('x')), -1) - 5;
ax_y_min = round(min(values.('y')), -1) - 5;

% Dessin de la flèche d'axe
x_arrow = drawArrow([0, ax_x_max], [0, 0], 'linewidth',3,'color','k');
y_arrow_head_size = (x_arrow.MaxHeadSize * ax_x_max) / ax_y_max ;
drawArrow([0, 0], [0, ax_y_max], 'MaxHeadSize', y_arrow_head_size, 'linewidth',3,'color','k')

% Limites d'axe
xlim([ax_x_min, ax_x_max])
ylim([ax_y_min, ax_y_max])

% JOINTS du manipulateur sériel
scatter(values.('x')(1), values.('y')(1), 200, 'k', 'filled')
scatter(values.('x')(2:end-1), values.('y')(2:end-1), 'r', 'filled')
scatter(values.('x')(end), values.('y')(end), 'g', 'filled')

% OUTPUT des valeurs
fprintf('\n\nCoordonnees de l''organe terminal\n===============\n\nx: %f, y: %f\n\n\n', round(values.('x')(end), 3), round(values.('y')(end), 3))

% Sauvegarde de la figure dans un fichier
saveas(gcf, 'geometrie_directe.png')

