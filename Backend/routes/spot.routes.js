const express = require('express');
const router = express.Router();
const spotController = require('../controllers/spot.controller');
const verifyToken = require('../utils/authMiddleware');

router.post('/create', verifyToken, spotController.create);
router.get('/all', spotController.getAll);
router.delete('/delete/:id', spotController.delete);
router.put('/update/:id', spotController.update);
router.get('/get/:id', spotController.getById);


module.exports = router;
