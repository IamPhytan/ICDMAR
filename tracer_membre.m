function [fin_x, fin_y] = tracer_membre(idx, orig_x, orig_y, longueur, largeur, angle)
% tracer_membre - Trace un membre d'un manipulateur sériel, à partir de son origine et de sa taille.
%
% Syntax: [fin_x, fin_y] = tracer_membre(idx, orig_x, orig_y, longueur, largeur, angle)
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
% param angle      : Angle du membre par rapport à l'axe des x (en degrés)

% Positions

x_min = orig_x;
x_max = orig_x + longueur;

y_min = orig_y - largeur / 2;
y_max = orig_y + largeur / 2;

x = [x_min, x_max, x_max, x_min];
y = [y_min, y_min, y_max, y_max];


% Couleurs

couleurs = ['b', 'g', 'c', 'm', 'y', 'k'];
% couleurs = ('b')

c = couleurs(mod(idx, size(couleurs, 2)) + 1);


% patch
p = patch(x, y,'FaceColor', 'w', 'EdgeColor', c);


% rotation
% direction()




% Coordonnées de fin
fin_x = orig_x + longueur * cos(angle);
fin_y = orig_y + longueur * sin(angle);


end