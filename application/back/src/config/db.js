const mysql = require('mysql2/promise'); // Utilisation de mysql2 avec promesses
require('dotenv').config(); // Charge les variables d'environnement

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'passer', // Laissez vide si pas de mot de passe par défaut
    database: process.env.DB_NAME || 'safeswim_db', // Nom de votre base de données
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

module.exports = pool;