const express = require('express');
const router = express.Router();
const ratingController = require('../controllers/rating.controller');

router.post('/add', ratingController.add);
router.delete('/delete/:user_id/:spot_id', ratingController.delete);
router.put('/update/:user_id/:spot_id', ratingController.update);
router.get('/get/:user_id/:spot_id', ratingController.getByUserAndSpot);



module.exports = router;