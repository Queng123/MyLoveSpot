const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const verifyToken = require('../utils/authMiddleware');

router.post('/create', userController.create);
router.post('/login', userController.login);

router.post('/refresh-token', userController.refreshToken);
router.post('/logout', userController.logout);

router.get('/profile', verifyToken, userController.profile);
router.post('/change-password', verifyToken, userController.changePassword);

module.exports = router;
