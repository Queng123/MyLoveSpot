
const express = require('express');
const router = express.Router();
const tagController = require('../controllers/tag.controller');

router.post('/add', tagController.add);
router.get('/all/:spot_id', tagController.getAll);
router.delete('/delete/:spot_id/:tag_name', tagController.delete);

module.exports = router;
