const db = require('../database/db');

exports.addTag = async (spot_id, tag_name) => {
  const query = 'INSERT INTO tags (spot_id, tag_name) VALUES (?, ?)';
  const values = [spot_id, tag_name];

  try {
    await db.query(query, values);
    return 'Tag added successfully';
  } catch (err) {
    throw new Error('Error adding tag: ' + err.message);
  }
}

exports.getAllTags = async (spot_id) => {
  const query = 'SELECT * FROM tags WHERE spot_id = ?';
  const values = [spot_id];

  try {
    const [rows] = await db.query(query, values);
    return rows;
  } catch (err) {
    throw new Error('Error fetching tags: ' + err.message);
  }
}

exports.deleteTag = async (spot_id, tag_name) => {
  const query = 'DELETE FROM tags WHERE spot_id = ? AND tag_name = ?';
  const values = [spot_id, tag_name];

  try {
    const result = await db.query(query, values);
    if (result.affectedRows === 0) {
      throw new Error('Tag not found');
    }
    return 'Tag deleted successfully';
  } catch (err) {
    throw new Error('Error deleting tag: ' + err.message);
  }
}