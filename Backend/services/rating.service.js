const db = require('../database/db');

exports.addRating = async (user_id, spot_id, rating) => {
  try {
    const result = await db.query(
      `INSERT INTO Rating (user_id, spot_id, note)
       VALUES (?, ?, ?)`,
      [user_id, spot_id, rating]
    );

    const spotRatings = await db.query(
      `SELECT note FROM Rating WHERE spot_id = ?`,
      [spot_id]
    );

    const notes = spotRatings[0].map(row => row.note);
    const averageRating =
      notes.reduce((acc, val) => acc + val, 0) / notes.length;
    await db.query(
      `UPDATE Spots SET rating = ? WHERE id = ?`,
      [averageRating, spot_id]
    );
    if (result.rowCount === 0) {
      throw new Error('Rating not added');
    }
    return { "new_rating": averageRating };
  } catch (error) {
    console.error(error);
    throw new Error('Error adding rating');
  }
}

exports.deleteRating = async (user_id, spot_id) => {
  try {
    const result = await db.query(
      `DELETE FROM Rating WHERE user_id = ? AND spot_id = ?`,
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
      `UPDATE Rating SET note = ? WHERE user_id = ? AND spot_id = ?`,
      [user_id, spot_id, rating]
    );

    const spotRatings = await db.query(
      `SELECT rating FROM Rating WHERE spot_id = ?`,
      [spot_id]
    );
    const averageRating = spotRatings.rows.reduce((acc, row) => acc + row.rating, 0) / spotRatings.rowCount;
    await db.query(
      `UPDATE Spots SET rating = ? WHERE id = ?`,
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
    `SELECT * FROM Ratings WHERE user_id = ? AND spot_id = ?`,
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
