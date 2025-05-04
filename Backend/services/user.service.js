const db = require('../database/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

exports.createUser = async (name, email, password) => {
  try {
    const [existingUsers] = await db.execute(
      'SELECT * FROM User WHERE email = ?',
      [email]
    );
    if (existingUsers.length > 0) {
      throw new Error('User already exists');
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const [result] = await db.execute(
      'INSERT INTO User (name, email, password) VALUES (?, ?, ?)',
      [name, email, hashedPassword]
    );
    if (result.affectedRows === 0) {
      throw new Error('User creation failed');
    }

    const refreshToken = jwt.sign({ id: result.insertId, email }, process.env.JWT_SECRET, {
      expiresIn: '30d',
    });

    await db.execute(
      'INSERT INTO RefreshToken (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))',
      [result.insertId, refreshToken]
    );

    const jwtToken = jwt.sign({ id: result.insertId, email }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });
    if (!jwtToken) {
      throw new Error('JWT token creation failed');
    }
    const user = {
      id: result.insertId,
      name,
      email,
      token: jwtToken,
      refreshToken,
    };
    delete user.password;
    return user;
  } catch (error) {
    console.error(error);
    throw new Error(error.message || 'Error creating user');
  }
};

exports.login = async (email, password) => {
  if (!email || !password) {
    throw new Error('Email and password are required');
  }
  try {
    const [rows] = await db.execute(
      'SELECT * FROM User WHERE email = ?',
      [email]
    );

    if (rows.length === 0) {
      throw new Error('User not found');
    }

    if (!(await bcrypt.compare(password, rows[0].password))) {
      throw new Error('Invalid password');
    }

    const user = rows[0];
    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });
    user.token = token;
    user.refreshToken = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET, {
      expiresIn: '30d',
    });
    const res = await db.execute(
      'INSERT INTO RefreshToken (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 30 DAY))',
      [user.id, user.refreshToken]
    );
    if (res.affectedRows === 0) {
      throw new Error('Failed to create refresh token');
    }
    delete user.password;
    return user;
  } catch (error) {
    console.error(error);
    throw new Error(error.message || 'Error logging in');
  }
}

exports.refreshToken = async (token) => {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const [rows] = await db.execute(
      'SELECT * FROM RefreshToken WHERE user_id = ? AND token = ?',
      [decoded.id, token]
    );

    if (rows.length === 0) {
      throw new Error('Invalid refresh token');
    }

    const newToken = jwt.sign({ id: decoded.id, email: decoded.email }, process.env.JWT_SECRET, {
      expiresIn: '1h',
    });
    const newRefreshToken = jwt.sign({ id: decoded.id, email: decoded.email }, process.env.JWT_SECRET, {
      expiresIn: '30d',
    });
    const [result] = await db.execute(
      'UPDATE RefreshToken SET token = ?, expires_at = DATE_ADD(NOW(), INTERVAL 30 DAY) WHERE user_id = ? AND token = ?',
      [newRefreshToken, decoded.id, token]
    );
    if (result.affectedRows === 0) {
      throw new Error('Failed to refresh token');
    }
    return {
      token: newToken,
      refreshToken: newRefreshToken,
    };
  } catch (error) {
    console.error(error);
    throw new Error('Error refreshing token: ' + error.message);
  }
};

exports.logout = async (token) => {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const [result] = await db.execute(
      'DELETE FROM RefreshToken WHERE user_id = ? AND token = ?',
      [decoded.id, token]
    );

    if (result.affectedRows === 0) {
      throw new Error('Logout failed');
    }
  } catch (error) {
    console.error(error);
    throw new Error('Error logging out: ' + error.message);
  }
}

exports.getUserProfile = async (userId) => {
  try {
    const [rows] = await db.execute(
      'SELECT id, name, email FROM User WHERE id = ?',
      [userId]
    );

    if (rows.length === 0) {
      throw new Error('User not found');
    }

    return rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error fetching user profile: ' + error.message);
  }
};

exports.changePassword = async (userId, oldPassword, newPassword) => {
  try {
    const [rows] = await db.execute(
      'SELECT * FROM User WHERE id = ?',
      [userId]
    );

    if (rows.length === 0) {
      throw new Error('User not found');
    }

    const user = rows[0];
    if (!(await bcrypt.compare(oldPassword, user.password))) {
      throw new Error('Old password is incorrect');
    }

    const hashedNewPassword = await bcrypt.hash(newPassword, 10);
    const [result] = await db.execute(
      'UPDATE User SET password = ? WHERE id = ?',
      [hashedNewPassword, userId]
    );

    if (result.affectedRows === 0) {
      throw new Error('Password change failed');
    }
  } catch (error) {
    console.error(error);
    throw new Error('Error changing password: ' + error.message);
  }
};
