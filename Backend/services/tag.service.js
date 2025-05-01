const db = require('../database/db');

exports.addTag = async (tag_name) => {
  const query = 'INSERT INTO Tag (tag_name) VALUES (?)';
  const values = [tag_name];

  try {
    await db.query(query, values);
    return 'Tag added successfully';
  } catch (err) {
    throw new Error('Error adding tag: ' + err.message);
  }
}

exports.getAllTags = async () => {
  const query = 'SELECT * FROM Tag';

  try {
    const [rows] = await db.query(query);
    return rows;
  } catch (err) {
    throw new Error('Error fetching tags: ' + err.message);
  }
}

exports.deleteTag = async (tag_name) => {
  const query = 'DELETE FROM Tag WHERE tag_name = ?';
  const values = [tag_name];

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