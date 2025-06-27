
DROP TABLE IF EXISTS NageurAxeData;
DROP TABLE IF EXISTS Plage_Sauveteur;
DROP TABLE IF EXISTS Plage;
DROP TABLE IF EXISTS Nageur;
DROP TABLE IF EXISTS Sauveteur;


-- Table pour Sauveteur (inchangée)
CREATE TABLE Sauveteur (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL
);

-- Table pour Plage (inchangée)
CREATE TABLE Plage (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    lat DEcIMAL(10,8),
    longi DEcIMAL(10,8),
    drapeau VARCHAR(50),
    qualite VARCHAR(100),
    zone_rique JSON
);

-- Table de jointure Plage_Sauveteur (inchangée)
CREATE TABLE Plage_Sauveteur (
    plage_id BIGINT,
    sauveteur_id BIGINT,
    PRIMARY KEY (plage_id, sauveteur_id),
    FOREIGN KEY (plage_id) REFERENCES Plage(id) ON DELETE CASCADE,
    FOREIGN KEY (sauveteur_id) REFERENCES Sauveteur(id) ON DELETE CASCADE
);

-- Table pour Nageur (MODIFIÉE : 'axes' est retiré)
CREATE TABLE Nageur (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nom_c VARCHAR(255) NOT NULL,
    lat DECIMAL(10,8),
    longi DECIMAL(10,8),
    last_mess DATETIME(6)
);

-- NOUVELLE Table pour les données de l'accéléromètre
CREATE TABLE NageurAxeData (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nageur_id BIGINT NOT NULL, -- Clé étrangère vers la table Nageur
    accel_x DOUBLE,           -- Composante X de l'accélération
    accel_y DOUBLE,           -- Composante Y de l'accélération
    accel_z DOUBLE,           -- Composante Z de l'accélération
    timestamp DATETIME(6),    -- Moment de la lecture (peut être last_mess du nageur ou un champ séparé)
    -- Vous pouvez ajouter d'autres champs pertinents ici, ex:
    -- orientation_x DOUBLE,
    -- orientation_y DOUBLE,
    -- orientation_z DOUBLE,
    FOREIGN KEY (nageur_id) REFERENCES Nageur(id) ON DELETE CASCADE
);