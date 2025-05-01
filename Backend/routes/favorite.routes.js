
const express = require('express');
const router = express.Router();
const favoriteController = require('../controllers/favorite.controller');
const verifyToken = require('../utils/authMiddleware');

router.post('/add', verifyToken, favoriteController.add);
router.get('/all', verifyToken, favoriteController.getAll);
router.delete('/delete/:spot_id', verifyToken, favoriteController.delete);
router.get('/get/:spot_id', verifyToken, favoriteController.isFavorite);

module.exports = router;
