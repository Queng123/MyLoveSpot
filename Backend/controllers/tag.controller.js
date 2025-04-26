const tagService = require('../services/tag.service');

exports.add = async (req, res) => {
  const { spot_id, tag_name } = req.body;

  try {
    const message = await tagService.addTag(spot_id, tag_name);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.getAll = async (req, res) => {
  const { spot_id } = req.params;

  try {
    const tags = await tagService.getAllTags(spot_id);
    res.json(tags);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.delete = async (req, res) => {
  const { spot_id, tag_name } = req.params;

  try {
    const message = await tagService.deleteTag(spot_id, tag_name);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
