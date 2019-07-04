

config_file_path = [pwd filesep 'config.txt'];

if ~isfile(config_file_path)
    config_file_contents = "Configuration en cinematique directe des membres du manipulateur seriel" + newline;
    config_file_contents = config_file_contents + "==============================================" + newline;
    config_file_contents = config_file_contents + "Entrez vos parametres a partir de la ligne 12, apres la ligne de '*'" + newline;
    config_file_contents = config_file_contents + "" + newline;
    config_file_contents = config_file_contents + "Utilisez la syntaxe suivante :" + newline;
    config_file_contents = config_file_contents + "<longueur> <largeur> <angle>" + newline;
    config_file_contents = config_file_contents + "" + newline;
    config_file_contents = config_file_contents + "Par exemple, pour un membre long de 5 unites, large de 2 unites, avec un angle de 60 degres par rapport au membre precedent :" + newline;
    config_file_contents = config_file_contents + "5 2 60" + newline;
    config_file_contents = config_file_contents + "" + newline;
    config_file_contents = config_file_contents + "******************************************" + newline;
    config_file_contents = config_file_contents + newline + newline + newline + newline + newline + newline;

    fid = fopen(config_file_path, 'wt');
    fprintf(fid, config_file_contents);
    fclose(fid);

    ME = MException('MATLAB:missingData', ...
    ['Fichier de configuration manquant', newline, ...
    'Veuillez ajouter vos valeurs au fichier de configuration qui fut cree au chemin suivant: <a href="matlab: open(''%s'')">%s</a>'], config_file_path, config_file_path);
    throw(ME)
end


% Lecture du fichier de configuration
fileID = fopen(config_file_path, 'r');
% fileID = fopen("./config.txt", 'r');
contents = textscan(fileID, '%f %f %f\r\n', 'HeaderLines', 11);
fclose(fileID);


% Vérifie la présence de données dans le fichier
if numel(contents{1}) == 0
    ME = MException('MATLAB:missingData', ...
    'Il manque des donnees dans le fichier de configuration (<a href="matlab: open(''%s'')">%s</a>)', config_file_path, config_file_path);
    throw(ME)
end

% Verifie si toutes les colonnes ont le même nombre de valeurs
num_colonnes = numel(contents);
if num_colonnes ~= 3
    warning("Une ligne du fichier de configuration a trop de donnees")
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

% Valeurs de x et y
values.('x') = 0;
values.('y') = 0;

% Creation de la figure et maintien du trace
figure
axis equal
grid on
hold on

% Dict des donnees
data.('long') = 0;
data.('larg') = 0;
data.('ang') = 0;


for i=1:n
    % Parametres
    long = contents{1}(i);
    larg = contents{2}(i);
    ang = contents{3}(i);
    
    fin_pnts = tracer_membre(i, values.('x')(end), values.('y')(end), long, larg, data.('ang')(end) + ang);
    values.('x') = [values.('x'), fin_pnts(1)];
    values.('y') = [values.('y'), fin_pnts(2)];

    data.('long') = [data.('long'), long];
    data.('larg') = [data.('larg'), larg];
    data.('ang') = [data.('ang'), ang];

end

% Remove first data
data.('long') = data.('long')(2:end);
data.('larg') = data.('larg')(2:end);
data.('ang') = data.('ang')(2:end);


% JOINTS du manipulateur seriel
tracer_cercle(values.('x')(1), values.('y')(1), data.('larg')(1), 'k')

for idx=2:(numel(values.('x'))-1)
    taille = max(data.('larg')(idx - 1), data.('larg')(idx));
    tracer_cercle(values.('x')(idx), values.('y')(idx), taille, 'r')
end

tracer_cercle(values.('x')(end), values.('y')(end), data.('larg')(end), 'g')


% AXES
arm_range = sum(data.('long'));
window_range = round(arm_range, -1) + 10;

% Fonction pour dessiner des fleches
drawArrow = @(x,y, varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );

% Dessin de la fleche d'axe
drawArrow([0, window_range], [0, 0], 'linewidth',3,'color','k')
drawArrow([0, 0], [0, window_range], 'linewidth',3,'color','k')

% Limites d'axe
xlim([-window_range, window_range])
ylim([-window_range, window_range])


% OUTPUT des valeurs
fprintf('\n\nCoordonnees de l''organe terminal\n===============\n\nx: %f, y: %f\n\n\n', round(values.('x')(end), 3), round(values.('y')(end), 3))

% Sauvegarde de la figure dans un fichier
saveas(gcf, 'geometrie_directe.png')

