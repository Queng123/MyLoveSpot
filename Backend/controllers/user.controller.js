const userService = require('../services/user.service');

exports.register = async (req, res) => {
  const { name, email, password } = req.body;

  try {
    const message = await userService.createUser(name, email, password);
    res.json( message );
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.login = async (req, res) => {
  const { email, password } = req.body;

  try {
    const token = await userService.login(email, password);
    res.json(token);
  } catch (err) {
    res.status(401).json({ error: err.message });
  }
}

exports.refreshToken = async (req, res) => {
  const { token } = req.body;

  try {
    const tokens = await userService.refreshToken(token);
    if (!tokens || !tokens.token || !tokens.refreshToken) {
      throw new Error('Invalid token');
    }

    res.json(tokens);
  } catch (err) {
    res.status(401).json({ error: err.message });
  }
};

exports.logout = async (req, res) => {
  const { token } = req.body;

  try {
    await userService.logout(token);
    res.json({ message: 'Logged out successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

exports.profile = async (req, res) => {
  const userId = req.user.id;

  try {
    const userProfile = await userService.getUserProfile(userId);
    res.json(userProfile);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
exports.changePassword = async (req, res) => {
  const userId = req.user.id;
  const { oldPassword, newPassword } = req.body;

  try {
    await userService.changePassword(userId, oldPassword, newPassword);
    res.json({ message: 'Password changed successfully' });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};
