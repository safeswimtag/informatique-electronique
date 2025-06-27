const express = require('express');
const router = express.Router();
const nageurController = require('../controllers/nageurController');
// Pas besoin d'importer nageurAxeDataRoutes ici car c'est géré dans app.js
// via une route imbriquée: app.use('/api/nageurs/:nageurId/axe-data', nageurAxeDataRoutes);

router.get('/', nageurController.getAllNageurs);
router.get('/:id', nageurController.getNageurById);
router.post('/', nageurController.createNageur);
router.put('/:id', nageurController.updateNageur);
router.delete('/:id', nageurController.deleteNageur);

module.exports = router;