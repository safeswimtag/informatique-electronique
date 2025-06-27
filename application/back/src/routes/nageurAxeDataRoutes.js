const express = require('express');
const router = express.Router({ mergeParams: true }); // mergeParams pour accéder à :nageurId
const nageurAxeDataController = require('../controllers/nageurAxeDataController');

// Récupérer toutes les données d'axe pour un nageur
router.get('/', nageurAxeDataController.getAllAxeDataForNageur);
// Récupérer une donnée d'axe spécifique par son ID (pourrait être moins utile)
router.get('/:axeDataId', nageurAxeDataController.getAxeDataById);
// Ajouter une nouvelle donnée d'axe pour un nageur
router.post('/', nageurAxeDataController.createAxeDataForNageur);
// Mettre à jour une donnée d'axe spécifique (moins courant pour des lectures de capteur)
router.put('/:axeDataId', nageurAxeDataController.updateAxeData);
// Supprimer une donnée d'axe spécifique
router.delete('/:axeDataId', nageurAxeDataController.deleteAxeData);

module.exports = router;