const express = require('express');
const router = express.Router();
const sauveteurController = require('../controllers/sauveteurController');

router.get('/', sauveteurController.getAllSauveteurs);
router.get('/:id', sauveteurController.getSauveteurById);
router.post('/', sauveteurController.createSauveteur);
router.put('/:id', sauveteurController.updateSauveteur);
router.delete('/:id', sauveteurController.deleteSauveteur);

// Optionnel: Récupérer les plages d'un sauveteur spécifique
router.get('/:id/plages', sauveteurController.getPlagesBySauveteurId);

module.exports = router;
