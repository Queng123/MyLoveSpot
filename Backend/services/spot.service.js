const db = require('../database/db');

exports.createSpot = async (
  name,
  description,
  address,
  creator_id,
  longitude,
  latitude,
  logo,
  color,
  image,
  link,
  tags
) => {
  try {
    const [result] = await db.query(
      `INSERT INTO Spots (name, description, address, creator_id, longitude, latitude, logo, rating, color, image, link)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [name, description, address, creator_id, longitude, latitude, logo, 0, color, image, link]
    );

    for (const tag of tags) {
      const [existingTag] = await db.query('SELECT id FROM Tag WHERE name = ?', [tag]);
      const [tagResult] = await db.query(
        `INSERT INTO SpotTags (spot_id, tag_id)
         SELECT ?, id FROM Tag WHERE name = ?`,
        [result.insertId, existingTag]
      );
      if (!tagResult.insertId) {
        throw new Error(`Error inserting tag: ${tag}`);
      }
    }
    return result.insertId
  } catch (error) {
    console.error(error);
    throw new Error('Error creating spot');
  }
};

exports.getAllSpots = async () => {
  try {
    const result = await db.query('SELECT * FROM Spots');
    return result[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error fetching spots');
  }
};

exports.deleteSpot = async (id) => {
  try {
    const result = await db.query('DELETE FROM Spots WHERE id = ?', [id]);
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
  longitude,
  latitude,
  logo,
  color,
  image,
  link,
  tags
) => {
  try {
    const result = await db.query(
      `UPDATE Spots
      SET name = ?, description = ?, address = ?, longitude = ?, latitude = ?, logo = ?, color = ?, image = ?, link = ?
      WHERE id = ?`,
      [name, description, address, longitude, latitude, logo, color, image, link, id]
    );

    if (result.rowCount === 0) {
      throw new Error('Spot not found');
    }

    await db.query('DELETE FROM SpotTags WHERE spot_id = ?', [id]);
    for (const tag of tags) {
      const [existingTag] = await db.query('SELECT id FROM Tag WHERE name = ?', [tag]);
      const [tagResult] = await db.query(
        `INSERT INTO SpotTags (spot_id, tag_id)
         SELECT ?, id FROM Tag WHERE name = ?`,
        [result.insertId, existingTag]
      );
      if (!tagResult.insertId) {
        throw new Error(`Error inserting tag: ${tag}`);
      }
    }
    return result[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error updating spot');
  }
}

exports.getSpotById = async (id) => {
  try {
    const result = await db.query('SELECT * FROM Spots WHERE id = ?', [id]);
    console.log(result);
    if (result.rowCount === 0) {
      return null;
    }
    return result[0];
  } catch (error) {
    console.error(error);
    throw new Error('Error fetching spot by ID');
  }
}
