const db = require('../database/db');

exports.createSpot = async (
  name,
  description,
  address,
  creator_id,
  longitude,
  latitude,
  logo,
  rating,
  color,
  image,
  link
) => {
  try {
    const result = await db.query(
      `INSERT INTO Spots (name, description, address, creator_id, longitude, latitude, logo, rating, color, image, link)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [name, description, address, creator_id, longitude, latitude, logo, rating, color, image, link]
    );

    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error creating spot');
  }
};

exports.getAllSpots = async () => {
  try {
    const result = await db.query('SELECT * FROM Spots');
    return result.rows;
  } catch (error) {
    console.error(error);
    throw new Error('Error fetching spots');
  }
};

exports.deleteSpot = async (id) => {
  try {
    const result = await db.query('DELETE FROM Spots WHERE id = $1 RETURNING *', [id]);
    if (result.rowCount === 0) {
      throw new Error('Spot not found');
    }
    return `Spot with ID ${id} deleted successfully`;
  } catch (error) {
    console.error(error);
    throw new Error('Error deleting spot');
  }
};

exports.updateSpot = async (
  id,
  name,
  description,
  address,
  creator_id,
  longitude,
  latitude,
  logo,
  rating,
  color,
  image,
  link
) => {
  try {
    const result = await db.query(
      `UPDATE Spots
       SET name = $1, description = $2, address = $3, creator_id = $4, longitude = $5,
           latitude = $6, logo = $7, rating = $8, color = $9, image = $10, link = $11
       WHERE id = $12
       RETURNING *`,
      [name, description, address, creator_id, longitude, latitude, logo, rating, color, image, link, id]
    );

    if (result.rowCount === 0) {
      throw new Error('Spot not found');
    }
    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error updating spot');
  }
}

exports.getSpotById = async (id) => {
  try {
    const result = await db.query('SELECT * FROM Spots WHERE id = $1', [id]);
    if (result.rowCount === 0) {
      return null;
    }
    return result.rows[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error fetching spot by ID');
  }
}
