const router = require('express').Router();
const userRoute = require('./user.routes');
const spotRoute = require('./spot.routes');
const favoriteRoute = require('./favorite.routes');
const ratingRoute = require('./rating.routes');
const tagRoute = require('./tag.routes');

router.use('/user', userRoute);
router.use('/spot', spotRoute);
router.use('/favorite', favoriteRoute);
router.use('/rating', ratingRoute);
router.use('/tag', tagRoute);



router.get('/', (req, res) => {
    res.send('Hello From the server');
});

module.exports = router;