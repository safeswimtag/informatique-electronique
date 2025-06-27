CREATE DATABASE IF NOT EXISTS safe_swim_enquete;
USE safe_swim_enquete;

CREATE TABLE IF NOT EXISTS reponses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  role VARCHAR(50),
  frequence TEXT,
  causes TEXT,
  comportement TEXT,
  detection TEXT,
  faiblesses TEXT,
  zones TEXT,
  drapeaux TEXT,
  signal_comprehension TEXT,
  avis TEXT,
  publics TEXT,
  interet VARCHAR(20),
  nom VARCHAR(100),
  prenom VARCHAR(100),
  email VARCHAR(150),
  telephone VARCHAR(20),
  date_soumission TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
