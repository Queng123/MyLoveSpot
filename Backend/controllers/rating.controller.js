const ratingService = require('../services/rating.service');

exports.add = async (req, res) => {
  const { spot_id, rating } = req.body;
  const user_id = req.user.id;
  try {
    const message = await ratingService.addRating(user_id, spot_id, rating);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.delete = async (req, res) => {
  const { spot_id } = req.params;
  const user_id = req.user.id;

  try {
    const message = await ratingService.deleteRating(user_id, spot_id);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.update = async (req, res) => {
  const { spot_id } = req.params;
  const { rating } = req.body;
  const user_id = req.user.id;

  try {
    const message = await ratingService.updateRating(user_id, spot_id, rating);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.getByUserAndSpot = async (req, res) => {
  const { spot_id } = req.params;
  const user_id = req.user.id;
  try {
    const rating = await ratingService.getRatingByUserAndSpot(user_id, spot_id);
    res.json(rating);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}