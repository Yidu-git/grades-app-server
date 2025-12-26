import pool from "../config/db.js";

export const createNote = async (data) => {
  const {
    userID,
    userName,
    title,
    note,
    description,
    tags,
    category,
    Private,
  } = data;
  const created_at = new Date();

  const query = `
    INSERT INTO Notes (UserID, UserName, Private, title, note, description, tags, category, created_at)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;
  const values = [
    userID,
    userName,
    Private,
    title,
    note,
    description,
    JSON.stringify(tags),
    category,
    created_at,
  ];

  const [result] = await pool.query(query, values);
  const [rows] = await pool.execute("SELECT * FROM notes WHERE id = (?)", [
    result.insertId,
  ]);
  return rows[0];

  //   UserID` BIGINT NOT NULL,
  //     `Private` BOOL NOT NULL DEFAULT TRUE,
  //     `title` VARCHAR(50) NOT NULL,
  //     `note` MULTILINESTRING NULL,
  //     `CourseID` BIGINT NULL,
  //     `description` TEXT NULL,
  //     `tags` JSON NULL,
  //     `unit` VARCHAR(20) NULL,
  //     `catagory` VARCHAR(255) NULL
};

export const searchNotes = async (search) => {};

export const findNote = async (id) => {
  const [rows] = await pool.execute("SELECT * FROM notes WHERE id = ?", [id]);
  return rows[0];
};

export const getPublicNotes = async (limit) => {
  if (limit === "0") {
    const [rows] = await pool.execute(
      "SELECT * FROM notes WHERE Private = false"
    );
    return rows;
  }
  const [rows] = await pool.execute(
    "SELECT * FROM notes WHERE Private = false LIMIT ?",
    [limit]
  );
  return rows;
};

export const getNotes = async (user, limit) => {
  if (limit === "0") {
    const [rows] = await pool.execute(
      "SELECT * FROM notes WHERE UserName = ?",
      [user.name]
    );
    return rows;
  }
  const [rows] = await pool.execute(
    "SELECT * FROM notes WHERE UserName = ?  LIMIT ?",
    [user.name, limit]
  );
  return rows;
};

export const deleteNote = async (id) => {
  await pool.query("DELETE FROM notes WHERE id = ?", [id]);
};

export const editNote = async (id, data) => {
  const feilds = data.keys();
  const values = [];

  const query = `
    UPDATE notes
    SET ${feilds.join(", ")}
    WHERE id = ${id}
    RETURNING id, title, note
    `;
  const result = await pool.query(query, values);
  return result.rows[0];
};
