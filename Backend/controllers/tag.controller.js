const tagService = require('../services/tag.service');

exports.add = async (req, res) => {
  const { tag_name } = req.body;

  try {
    const message = await tagService.addTag(tag_name);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.getAll = async (req, res) => {
  try {
    const tags = await tagService.getAllTags();
    res.json(tags);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.delete = async (req, res) => {
  const { tag_name } = req.params;

  try {
    const message = await tagService.deleteTag(tag_name);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
