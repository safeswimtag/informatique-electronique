const pool = require('../config/db');

// Fonction utilitaire pour parser les champs JSON de la DB
const parsePlageData = (plage) => {
    if (plage.zone_rique) {
        try {
            plage.zone_rique = JSON.parse(plage.zone_rique);
        } catch (e) {
            console.error("Erreur lors du parsing de 'zone_rique' JSON:", e);
            plage.zone_rique = [];
        }
    }
    return plage;
};

exports.getAllPlages = async (req, res) => {
    try {
        // Sélectionne toutes les plages et les informations de leurs sauveteurs associés
        const [rows] = await pool.query(`
            SELECT
                p.*,
                JSON_ARRAYAGG(JSON_OBJECT('id', s.id, 'nom', s.nom)) AS sauveteurs
            FROM Plage p
            LEFT JOIN Plage_Sauveteur ps ON p.id = ps.plage_id
            LEFT JOIN Sauveteur s ON ps.sauveteur_id = s.id
            GROUP BY p.id
        `);
        const plages = rows.map(plage => {
            const parsedPlage = parsePlageData(plage);
            // JSON_ARRAYAGG retourne un tableau JSON, qui est déjà un objet JS si bien formé.
            // Cependant, s'il n'y a pas de sauveteurs, il peut renvoyer [null] ou une chaîne vide.
            if (parsedPlage.sauveteurs && parsedPlage.sauveteurs.length === 1 && parsedPlage.sauveteurs[0] === null) {
                parsedPlage.sauveteurs = [];
            }
            return parsedPlage;
        });
        res.json(plages);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.getPlageById = async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT
                p.*,
                JSON_ARRAYAGG(JSON_OBJECT('id', s.id, 'nom', s.nom)) AS sauveteurs
            FROM Plage p
            LEFT JOIN Plage_Sauveteur ps ON p.id = ps.plage_id
            LEFT JOIN Sauveteur s ON ps.sauveteur_id = s.id
            WHERE p.id = ?
            GROUP BY p.id
        `, [req.params.id]);

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Plage non trouvée' });
        }
        const plage = parsePlageData(rows[0]);
        // if (plage.sauveteurs && plage.sauveteurs.length === 1 && plage.sauveteurs[0] === null) {
        //     plage.sauveteurs = ;
        // }
        res.json(plage);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.createPlage = async (req, res) => {
    // La requête POST pour créer une plage n'inclut plus les sauveteurs directement
    const { nom, lat, long, drapeau, qualite, zone_rique } = req.body;
    try {
        const stringifiedZoneRique = zone_rique ? JSON.stringify(zone_rique) : null;

        const [result] = await pool.query(
            'INSERT INTO Plage (nom, lat, long, drapeau, qualite, zone_rique) VALUES (?, ?, ?, ?, ?, ?)',
            [nom, lat, long, drapeau, qualite, stringifiedZoneRique]
        );
        res.status(201).json({ id: result.insertId, ...req.body });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la création de la plage' });
    }
};

exports.updatePlage = async (req, res) => {
    // La requête PUT pour mettre à jour une plage n'inclut plus les sauveteurs directement
    const { nom, lat, long, drapeau, qualite, zone_rique } = req.body;
    const { id } = req.params;
    try {
        const stringifiedZoneRique = zone_rique ? JSON.stringify(zone_rique) : null;

        const [result] = await pool.query(
            'UPDATE Plage SET nom = ?, lat = ?, long = ?, drapeau = ?, qualite = ?, zone_rique = ? WHERE id = ?',
            [nom, lat, long, drapeau, qualite, stringifiedZoneRique, id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Plage non trouvée' });
        }
        res.json({ message: 'Plage mise à jour avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la mise à jour de la plage' });
    }
};

exports.deletePlage = async (req, res) => {
    try {
        const [result] = await pool.query('DELETE FROM Plage WHERE id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Plage non trouvée' });
        }
        res.json({ message: 'Plage supprimée avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la suppression de la plage' });
    }
};

// NOUVEAUX Endpoints pour gérer les associations Plage-Sauveteur

// Associer un sauveteur à une plage
exports.addSauveteurToPlage = async (req, res) => {
    const { plageId } = req.params;
    const { sauveteurId } = req.body; // Attendre l'ID du sauveteur dans le corps
    try {
        // Vérifier si la plage et le sauveteur existent
        const [plageExists] = await pool.query('SELECT id FROM Plage WHERE id = ?', [plageId]);
        const [sauveteurExists] = await pool.query('SELECT id FROM Sauveteur WHERE id = ?', [sauveteurId]);

        if (plageExists.length === 0) {
            return res.status(404).json({ message: 'Plage non trouvée' });
        }
        if (sauveteurExists.length === 0) {
            return res.status(404).json({ message: 'Sauveteur non trouvé' });
        }

        // Insérer l'association
        await pool.query('INSERT INTO Plage_Sauveteur (plage_id, sauveteur_id) VALUES (?, ?)', [plageId, sauveteurId]);
        res.status(201).json({ message: 'Sauveteur associé à la plage avec succès' });
    } catch (err) {
        // Gérer les cas où l'association existe déjà (doublon sur clé primaire)
        if (err.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({ message: 'Cette association existe déjà' });
        }
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de l\'association du sauveteur' });
    }
};

// Dissocier un sauveteur d'une plage
exports.removeSauveteurFromPlage = async (req, res) => {
    const { plageId, sauveteurId } = req.params; // Attendre l'ID du sauveteur dans l'URL
    try {
        const [result] = await pool.query(
            'DELETE FROM Plage_Sauveteur WHERE plage_id = ? AND sauveteur_id = ?',
            [plageId, sauveteurId]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Association non trouvée' });
        }
        res.json({ message: 'Sauveteur dissocié de la plage avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la dissociation du sauveteur' });
    }
};

// Récupérer tous les sauveteurs d'une plage spécifique
exports.getSauveteursByPlageId = async (req, res) => {
    try {
        const [rows] = await pool.query(
            `SELECT s.id, s.nom
             FROM Sauveteur s
             JOIN Plage_Sauveteur ps ON s.id = ps.sauveteur_id
             WHERE ps.plage_id = ?`,
            [req.params.plageId]
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la récupération des sauveteurs de la plage' });
    }
};