const db = require('../database/db');

exports.addRating = async (user_id, spot_id, rating) => {
  try {
    const result = await db.query(
      `INSERT INTO Ratings (user_id, spot_id, rating)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [user_id, spot_id, rating]
    );

    const spotRatings = await db.query(
      `SELECT rating FROM Ratings WHERE spot_id = $1`,
      [spot_id]
    );

    const averageRating = spotRatings.rows.reduce((acc, row) => acc + row.rating, 0) / spotRatings.rowCount;

    await db.query(
      `UPDATE Spots SET rating = $1 WHERE id = $2`,
      [averageRating, spot_id]
    );
    if (result.rowCount === 0) {
      throw new Error('Rating not added');
    }

    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error adding rating');
  }
}

exports.deleteRating = async (user_id, spot_id) => {
  try {
    const result = await db.query(
      `DELETE FROM Ratings WHERE user_id = $1 AND spot_id = $2 RETURNING *`,
      [user_id, spot_id]
    );

    if (result.rowCount === 0) {
      throw new Error('Rating not found');
    }

    return `Rating for Spot ID ${spot_id} deleted successfully`;
  } catch (error) {
    console.error(error);
    throw new Error('Error deleting rating');
  }
}

exports.updateRating = async (user_id, spot_id, rating) => {
  try {
    const result = await db.query(
      `UPDATE Ratings SET rating = $3 WHERE user_id = $1 AND spot_id = $2 RETURNING *`,
      [user_id, spot_id, rating]
    );

    const spotRatings = await db.query(
      `SELECT rating FROM Ratings WHERE spot_id = $1`,
      [spot_id]
    );
    const averageRating = spotRatings.rows.reduce((acc, row) => acc + row.rating, 0) / spotRatings.rowCount;
    await db.query(
      `UPDATE Spots SET rating = $1 WHERE id = $2`,
      [averageRating, spot_id]
    );

    if (result.rowCount === 0) {
      throw new Error('Rating not found');
    }

    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error updating rating');
  }
}

exports.getRatingByUserAndSpot = async (user_id, spot_id) => {
  try {
    const result = await db.query(
      `SELECT * FROM Ratings WHERE user_id = $1 AND spot_id = $2`,
      [user_id, spot_id]
    );

    if (result.rowCount === 0) {
      throw new Error('Rating not found');
    }

    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error retrieving rating');
  }
}
