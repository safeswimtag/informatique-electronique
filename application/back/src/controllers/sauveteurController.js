const pool = require('../config/db');

exports.getAllSauveteurs = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM Sauveteur');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la récupération des sauveteurs' });
    }
};

exports.getSauveteurById = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM Sauveteur WHERE id = ?', [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ message: 'Sauveteur non trouvé' });
        }
        res.json(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.createSauveteur = async (req, res) => {
    const { nom } = req.body;
    if (!nom) {
        return res.status(400).json({ message: 'Le nom du sauveteur est requis' });
    }
    try {
        const [result] = await pool.query('INSERT INTO Sauveteur (nom) VALUES (?)', [nom]);
        res.status(201).json({ id: result.insertId, nom });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la création du sauveteur' });
    }
};

exports.updateSauveteur = async (req, res) => {
    const { nom } = req.body;
    const { id } = req.params;
    if (!nom) {
        return res.status(400).json({ message: 'Le nom du sauveteur est requis' });
    }
    try {
        const [result] = await pool.query('UPDATE Sauveteur SET nom = ? WHERE id = ?', [nom, id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Sauveteur non trouvé' });
        }
        res.json({ message: 'Sauveteur mis à jour avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la mise à jour du sauveteur' });
    }
};

exports.deleteSauveteur = async (req, res) => {
    try {
        const [result] = await pool.query('DELETE FROM Sauveteur WHERE id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Sauveteur non trouvé' });
        }
        res.json({ message: 'Sauveteur supprimé avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la suppression du sauveteur' });
    }
};

// Fonction pour récupérer toutes les plages associées à un sauveteur
exports.getPlagesBySauveteurId = async (req, res) => {
    try {
        const [rows] = await pool.query(
            `SELECT p.*
             FROM Plage p
             JOIN Plage_Sauveteur ps ON p.id = ps.plage_id
             WHERE ps.sauveteur_id = ?`,
            [req.params.id]
        );
        // N'oubliez pas de parser les champs JSON de Plage si nécessaire
        const plages = rows.map(plage => {
            if (plage.zone_rique) {
                try {
                    plage.zone_rique = JSON.parse(plage.zone_rique);
                } catch (e) { /* Gérer l'erreur */ }
            }
            return plage;
        });
        res.json(plages);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la récupération des plages du sauveteur' });
    }
};