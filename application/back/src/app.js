const express = require('express');
const dotenv = require('dotenv');
const plageRoutes = require('./routes/plageRoutes');
const nageurRoutes = require('./routes/nageurRoutes');
const sauveteurRoutes = require('./routes/sauveteurRoutes');
const nageurAxeDataRoutes = require('./routes/nageurAxeDataRoutes'); // NOUVEAU

dotenv.config();

const app = express();
app.use(express.json());

// Routes API
app.use('/api/plages', plageRoutes);
app.use('/api/nageurs', nageurRoutes);
app.use('/api/sauveteurs', sauveteurRoutes);
app.use('/api/nageurs/:nageurId/axe-data', nageurAxeDataRoutes); // NOUVEAU, imbriqué sous /api/nageurs

app.get('/', (req, res) => {
    res.send('Bienvenue sur l\'API Backend !');
});

module.exports = app;