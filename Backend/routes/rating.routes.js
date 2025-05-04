const express = require('express');
const router = express.Router();
const ratingController = require('../controllers/rating.controller');
const verifyToken = require('../utils/authMiddleware');

router.post('/add', verifyToken, ratingController.add);
router.delete('/delete/:spot_id', verifyToken, ratingController.delete);
router.put('/update/:spot_id', verifyToken, ratingController.update);
router.get('/get/:spot_id', verifyToken, ratingController.getByUserAndSpot);



module.exports = router;