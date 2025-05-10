const db = require('../database/db');

exports.addFavorite = async ({ user_id, spot_id, is_favorite }) => {
  try {
    if (is_favorite) {
      const [existingFavorite] = await db.query(
        `SELECT * FROM Favorites WHERE user_id = ? AND spot_id = ?`,
        [user_id, spot_id]
      );

      if (existingFavorite.length > 0) {
        await db.query(
          `UPDATE Favorites SET updated_at = NOW() WHERE user_id = ? AND spot_id = ?`,
          [user_id, spot_id]
        );
        return { message: 'Favorite updated' };
      } else {
        const [result] = await db.query(
          `INSERT INTO Favorites (user_id, spot_id) VALUES (?, ?)`,
          [user_id, spot_id]
        );
        return { message: 'Favorite added', favorite: result };
      }
    } else {
      const result = await db.query(
        `DELETE FROM Favorites WHERE user_id = ? AND spot_id = ?`,
        [user_id, spot_id]
      );

      if (result.rowCount > 0) {
        return { message: 'Favorite removed' };
      } else {
        return { message: 'No favorite found to remove' };
      }
    }
  } catch (error) {
    console.error(error);
    throw new Error('Error adding, updating, or deleting favorite');
  }
};

exports.getAllFavorites = async (user_id) => {
  try {
    const result = await db.query(
      `SELECT * FROM Favorites WHERE user_id = ?`,
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
      `DELETE FROM Favorites WHERE user_id = ? AND spot_id = ?`,
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

exports.isFavorite = async (user_id, spot_id) => {
  try {
    const result = await db.query(
      `SELECT * FROM Favorites WHERE user_id = ? AND spot_id = ?`,
      [user_id, spot_id]
    );

    return result.rowCount > 0;
  } catch (error) {
    console.error(error);
    throw new Error('Error checking favorite status');
  }
};