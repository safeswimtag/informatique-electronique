INSERT INTO Sauveteur (nom) VALUES ('Moussa Fall');
INSERT INTO Sauveteur (nom) VALUES ('Fatou Dia');
INSERT INTO Sauveteur (nom) VALUES ('Pape Gueye');

INSERT INTO Plage (nom, lat, longi, drapeau, qualite, zone_rique)
VALUES ('Plage TERROU BI', 14.674896, -17.468946, 'Vert', 'Excellente', '[ [{"lat": 14.673605, "longi": -17.466962}, {"lat": 14.673798, "longi": -17.469942},{"lat": 14.669396, "longi": -17.471231}, {"lat": 14.671728, "longi": -17.465964}] ]');

INSERT INTO Nageur (nom_c, lat, longi, last_mess)
VALUES ('Barham', 14.674649, -17.468564, '2025-06-21 12:00:00.000000');

INSERT INTO Plage_Sauveteur (plage_id, sauveteur_id) VALUES (1, 1);

INSERT INTO NageurAxeData (nageur_id, accel_x, accel_y, accel_z, timestamp)
VALUES (1, 0.5, -0.2, 9.8, '2025-06-21 12:15:35.000000');