const db = require('../database/db');

exports.addFavorite = async ({ user_id, spot_id }) => {
  try {
    const result = await db.query(
      `INSERT INTO Favorites (user_id, spot_id)
       VALUES ($1, $2)
       RETURNING *`,
      [user_id, spot_id]
    );

    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error adding favorite');
  }
};

exports.getAllFavorites = async (user_id) => {
  try {
    const result = await db.query(
      `SELECT * FROM Favorites WHERE user_id = $1`,
      [user_id]
    );

    return result.rows;
  } catch (error) {
    console.error(error);
    throw new Error('Error fetching favorites');
  }
}

exports.deleteFavorite = async (user_id, spot_id) => {
  try {
    const result = await db.query(
      `DELETE FROM Favorites WHERE user_id = $1 AND spot_id = $2 RETURNING *`,
      [user_id, spot_id]
    );

    if (result.rowCount === 0) {
      throw new Error('Favorite not found');
    }

    return `Favorite with Spot ID ${spot_id} deleted successfully`;
  } catch (error) {
    console.error(error);
    throw new Error('Error deleting favorite');
  }
};