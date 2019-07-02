function point_fin = tracer_membre(idx, orig_x, orig_y, longueur, largeur, ang)
% tracer_membre - Trace un membre d'un manipulateur sériel, à partir de son origine et de sa taille.
%
% Syntax: point_fin = tracer_membre(idx, orig_x, orig_y, longueur, largeur, ang)
%
% Trace un membre d'un manipulateur sériel, à partir de son origine et de sa taille.
% 
% Paramètres:
% 
% param idx        : ID du membre
% param orig_x     : Coordonnée en x de l'origine du membre
% param orig_y     : Coordonnée en y de l'origine du membre
% param largeur    : Largeur du membre
% param longueur   : Longueur du membre
% param ang        : ang du membre par rapport à l'axe des x (en degrés)

% Positions

x_min = orig_x;
x_max = orig_x + longueur;

y_min = orig_y - largeur / 2;
y_max = orig_y + largeur / 2;

x = [x_min, x_max, x_max, x_min];
y = [y_min, y_min, y_max, y_max];


% Couleurs

% couleurs = ['b', 'c', 'm', 'y'];
couleurs = ('b');

c = couleurs(mod(idx, size(couleurs, 2)) + 1);


% patch
p = patch(x, y,'w', 'EdgeColor', c);

% ROTATION DE LA FIGURE

direction = [0, 0, 1];
pnt_rotation = [orig_x, orig_y, 0];

rotate(p, direction, ang, pnt_rotation)

% Coordonnées de fin
fin_x = orig_x + longueur * cos(deg2rad(ang));
fin_y = orig_y + longueur * sin(deg2rad(ang));

% Traçage de la ligne du membre
plot([orig_x, fin_x], [orig_y, fin_y], '--', 'Color', c)

% Retour de la fin
point_fin = [fin_x, fin_y];


end