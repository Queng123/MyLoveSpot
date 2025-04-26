const spotService = require('../services/spot.service');

exports.create = async (req, res) => {
  const { name, email } = req.body;

  try {
    const message = await spotService.createspot(
      name,
      description,
      address,
      creator_id,
      longitude,
      latitude,
      logo,
      rating,
      color,
      image,
      link);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAll = async (req, res) => {
  try {
    const spots = await spotService.getAllSpots();
    res.json(spots);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.deleteSpot = async (req, res) => {
  const { id } = req.params;

  try {
    const message = await spotService.deleteSpot(id);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.updateSpot = async (req, res) => {
  const { id } = req.params;
  const { name, description, address, creator_id, longitude, latitude, logo, rating, color, image, link } = req.body;

  try {
    const message = await spotService.updateSpot(
      id,
      name,
      description,
      address,
      creator_id,
      longitude,
      latitude,
      logo,
      rating,
      color,
      image,
      link
    );
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.getSpotById = async (req, res) => {
  const { id } = req.params;

  try {
    const spot = await spotService.getSpotById(id);
    if (!spot) {
      return res.status(404).json({ error: 'Spot not found' });
    }
    res.json(spot);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}