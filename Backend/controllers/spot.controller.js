const spotService = require('../services/spot.service');

exports.create = async (req, res) => {
  const { name, description, address, longitude, latitude, logo, color, image, link, tags } = req.body;
  const creator_id = req.user.id;
  if (!name || !description || !address || !creator_id || !longitude || !latitude) {
    return res.status(400).json({ error: 'Missing required fields' });
  }
  try {
    const id = await spotService.createSpot(
      name,
      description,
      address,
      creator_id,
      longitude,
      latitude,
      logo,
      color,
      image,
      link,
      tags
    );
    res.json({ id });
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

exports.delete = async (req, res) => {
  const { id } = req.params;

  try {
    const message = await spotService.deleteSpot(id);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.update = async (req, res) => {
  const { id } = req.params;
  const { name, description, address, longitude, latitude, logo, color, image, link, tags } = req.body;

  try {
    const message = await spotService.updateSpot(
      id,
      name,
      description,
      address,
      longitude,
      latitude,
      logo,
      color,
      image,
      link,
      tags
    );
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.getById = async (req, res) => {
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