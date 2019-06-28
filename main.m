
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
    [~, I] = min(num_elems)
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
origine = [0, 0]

% Création de la figure et maintien du tracé
figure
hold on

for i=1:n
    % Paramètres
    long = contents{1}(i);
    larg = contents{2}(i);
    ang = contents{3}(i);
    
    origine = tracer_membre(i, origine(1), origine(2), long, larg, ang);

    scatter(origine(1), origine(2), 'r')
end

scatter(origine(1), origine(2), 'g')



