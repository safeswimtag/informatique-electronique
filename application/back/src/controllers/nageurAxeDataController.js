const pool = require('../config/db');

exports.getAllAxeDataForNageur = async (req, res) => {
    const { nageurId } = req.params;
    try {
        const [rows] = await pool.query('SELECT * FROM NageurAxeData WHERE nageur_id = ? ORDER BY timestamp DESC', [nageurId]);
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la récupération des données d\'axe' });
    }
};

exports.getAxeDataById = async (req, res) => {
    const { nageurId, axeDataId } = req.params;
    try {
        const [rows] = await pool.query('SELECT * FROM NageurAxeData WHERE id = ? AND nageur_id = ?', [axeDataId, nageurId]);
        if (rows.length === 0) {
            return res.status(404).json({ message: 'Donnée d\'axe non trouvée pour ce nageur' });
        }
        res.json(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.createAxeDataForNageur = async (req, res) => {
    const { nageurId } = req.params;
    const { accel_x, accel_y, accel_z, timestamp } = req.body;

    // Validation basique
    if (accel_x === undefined || accel_y === undefined || accel_z === undefined) {
        return res.status(400).json({ message: 'Les valeurs d\'accélération (x, y, z) sont requises.' });
    }

    try {
        // Vérifier si le nageur existe
        const [nageurExists] = await pool.query('SELECT id FROM Nageur WHERE id = ?', [nageurId]);
        if (nageurExists.length === 0) {
            return res.status(404).json({ message: 'Nageur non trouvé' });
        }

        // Utiliser le timestamp fourni ou l'actuel
        const finalTimestamp = timestamp ? new Date(timestamp).toISOString().slice(0, 23).replace('T', ' ') : new Date().toISOString().slice(0, 23).replace('T', ' ');

        const [result] = await pool.query(
            'INSERT INTO NageurAxeData (nageur_id, accel_x, accel_y, accel_z, timestamp) VALUES (?, ?, ?, ?, ?)',
            [nageurId, accel_x, accel_y, accel_z, finalTimestamp]
        );
        res.status(201).json({ id: result.insertId, nageur_id: nageurId, accel_x, accel_y, accel_z, timestamp: finalTimestamp });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de l\'ajout de la donnée d\'axe' });
    }
};

exports.updateAxeData = async (req, res) => {
    const { nageurId, axeDataId } = req.params;
    const { accel_x, accel_y, accel_z, timestamp } = req.body;

    if (accel_x === undefined && accel_y === undefined && accel_z === undefined && timestamp === undefined) {
        return res.status(400).json({ message: 'Au moins un champ (accel_x, accel_y, accel_z, timestamp) est requis pour la mise à jour.' });
    }

    const updates = [];
    const values = [];

    if (accel_x !== undefined) { updates.push('accel_x = ?'); values.push(accel_x); }
    if (accel_y !== undefined) { updates.push('accel_y = ?'); values.push(accel_y); }
    if (accel_z !== undefined) { updates.push('accel_z = ?'); values.push(accel_z); }
    if (timestamp !== undefined) {
        const finalTimestamp = new Date(timestamp).toISOString().slice(0, 23).replace('T', ' ');
        updates.push('timestamp = ?'); values.push(finalTimestamp);
    }

    if (updates.length === 0) {
        return res.status(400).json({ message: 'Aucun champ à mettre à jour.' });
    }

    values.push(axeDataId, nageurId); // Ajouter les IDs pour la clause WHERE

    try {
        const [result] = await pool.query(
            `UPDATE NageurAxeData SET ${updates.join(', ')} WHERE id = ? AND nageur_id = ?`,
            values
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Donnée d\'axe non trouvée ou n\'appartient pas à ce nageur' });
        }
        res.json({ message: 'Donnée d\'axe mise à jour avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la mise à jour de la donnée d\'axe' });
    }
};

exports.deleteAxeData = async (req, res) => {
    const { nageurId, axeDataId } = req.params;
    try {
        const [result] = await pool.query('DELETE FROM NageurAxeData WHERE id = ? AND nageur_id = ?', [axeDataId, nageurId]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Donnée d\'axe non trouvée ou n\'appartient pas à ce nageur' });
        }
        res.json({ message: 'Donnée d\'axe supprimée avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la suppression de la donnée d\'axe' });
    }
};