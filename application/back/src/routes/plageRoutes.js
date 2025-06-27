const express = require('express');
const router = express.Router();
const plageController = require('../controllers/plageController');

router.get('/', plageController.getAllPlages);
router.get('/:id', plageController.getPlageById);
router.post('/', plageController.createPlage);
router.put('/:id', plageController.updatePlage);
router.delete('/:id', plageController.deletePlage);

// NOUVELLES ROUTES pour les associations Sauveteur-Plage
router.post('/:plageId/sauveteurs', plageController.addSauveteurToPlage); // Associer un sauveteur à une plage
router.delete('/:plageId/sauveteurs/:sauveteurId', plageController.removeSauveteurFromPlage); // Dissocier un sauveteur
router.get('/:plageId/sauveteurs', plageController.getSauveteursByPlageId); // Récupérer les sauveteurs d'une plage

module.exports = router;