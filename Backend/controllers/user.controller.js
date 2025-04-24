const userService = require('../services/user.service');

exports.create = async (req, res) => {
  const { name, email } = req.body;

  try {
    const message = await userService.createUser(name, email);
    res.json({ message });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
