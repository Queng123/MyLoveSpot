const router = require('express').Router();
const userRoute = require('./user.routes');
const spotRoute = require('./spot.routes');
const favoriteRoute = require('./favorite.routes');

router.use('/user', userRoute);
router.use('/spot', spotRoute);
router.use('/favorite', favoriteRoute);


router.get('/', (req, res) => {
    res.send('Hello From the server');
});

module.exports = router;