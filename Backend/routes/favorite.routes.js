
const express = require('express');
const router = express.Router();
const favoriteController = require('../controllers/favorite.controller');

router.post('/add', favoriteController.add);
router.get('/all/:user_id', favoriteController.getAll);
router.delete('/delete/:user_id/:spot_id', favoriteController.delete);

module.exports = router;
