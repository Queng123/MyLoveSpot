const favoriteService = require('../services/favorite.service');

exports.add = async (req, res) => {
  const { spot_id } = req.body;
  const user_id = req.user.id;
  try {
    const message = await favoriteService.addFavorite(user_id, spot_id);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.getAll = async (req, res) => {
  const user_id = req.user.id;
  try {
    const favorites = await favoriteService.getAllFavorites(user_id);
    res.json(favorites);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.delete = async (req, res) => {
  const { spot_id } = req.params;
  const user_id = req.user.id;
  try {
    const message = await favoriteService.deleteFavorite(user_id, spot_id);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.isFavorite = async (req, res) => {
  const { spot_id } = req.params;
  const user_id = req.user.id;
  try {
    const isFavorite = await favoriteService.isFavorite(user_id, spot_id);
    res.json({ isFavorite });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
