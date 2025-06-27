const pool = require('../config/db');

exports.getAllNageurs = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM Nageur');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.getNageurById = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM Nageur WHERE id = ?', [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ message: 'Nageur non trouvé' });
        }
        res.json(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur' });
    }
};

exports.createNageur = async (req, res) => {
    const { nom_c, lat, long, last_mess } = req.body;
    try {
        const parsedLastMess = last_mess ? new Date(last_mess).toISOString().slice(0, 23).replace('T', ' ') : null;

        const [result] = await pool.query(
            'INSERT INTO Nageur (nom_c, lat, long, last_mess) VALUES (?, ?, ?, ?)',
            [nom_c, lat, long, parsedLastMess]
        );
        res.status(201).json({ id: result.insertId, ...req.body });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la création du nageur' });
    }
};

exports.updateNageur = async (req, res) => {
    const { nom_c, lat, long, last_mess } = req.body;
    const { id } = req.params;
    try {
        const parsedLastMess = last_mess ? new Date(last_mess).toISOString().slice(0, 23).replace('T', ' ') : null;

        const [result] = await pool.query(
            'UPDATE Nageur SET nom_c = ?, lat = ?, long = ?, last_mess = ? WHERE id = ?',
            [nom_c, lat, long, parsedLastMess, id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Nageur non trouvé' });
        }
        res.json({ message: 'Nageur mis à jour avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la mise à jour du nageur' });
    }
};

exports.deleteNageur = async (req, res) => {
    try {
        const [result] = await pool.query('DELETE FROM Nageur WHERE id = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Nageur non trouvé' });
        }
        res.json({ message: 'Nageur supprimé avec succès' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Erreur serveur lors de la suppression du nageur' });
    }
};