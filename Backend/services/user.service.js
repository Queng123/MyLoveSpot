const db = require('../database/db');

exports.createUser = async (name, email) => {
  try {
    const [result] = await db.execute(
      'INSERT INTO users (name, email) VALUES (?, ?)',
      [name, email]
    );
    return `User created with ID: ${result.insertId}`;
  } catch (error) {
    console.error(error);
    throw new Error('Error creating user');
  }
};
