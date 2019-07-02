function tracer_cercle(x, y, d, c)
% tracer_cercle - Traçage de cercle de couleur c
%
% Syntax: tracer_cercle(x, y, r, c)
%
% Traçage de cercle à partir du centre et du diamètre. Couleur c

r = d/2;
px = x-r;
py = y-r;
rectangle('Position',[px py d d],'Curvature',[1,1], 'EdgeColor', 'none', 'FaceColor', c)

end