const router = require('express').Router();
const userRoute = require('./user.routes');
const spotRoute = require('./spot.routes');

router.use('/user', userRoute);
router.use('/spot', spotRoute);


router.get('/', (req, res) => {
    res.send('Hello From the server');
});

module.exports = router;