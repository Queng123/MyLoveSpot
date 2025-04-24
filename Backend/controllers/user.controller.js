const userService = require('../services/user.service');

exports.create = (req, res) => {
  const result = userService.createUser();
  res.json({ message: result });
};
