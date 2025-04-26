const express = require('express');
const router = express.Router();
const spotController = require('../controllers/spot.controller');

router.post('/create', spotController.create);
router.get('/all', spotController.getAll);
router.delete('/delete/:id', spotController.deleteSpot);
router.put('/update/:id', spotController.updateSpot);
router.get('/get/:id', spotController.getSpotById);


module.exports = router;
