const router = require('express').Router();
const userRoute = require('./user.routes');

router.use('/user', userRoute);

router.get('/', (req, res) => {
    res.send('Hello From the server');
});

module.exports = router;