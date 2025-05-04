
const express = require('express');
const router = express.Router();
const tagController = require('../controllers/tag.controller');

router.post('/add', tagController.add);
router.get('/all', tagController.getAll);
router.delete('/delete/:tag_name', tagController.delete);

module.exports = router;
