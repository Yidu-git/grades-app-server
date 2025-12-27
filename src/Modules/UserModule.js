import pool from "../config/db.js";
import bcrypt from "bcryptjs";
import { generateAPIKEY } from "../utils/apiKeyGen.js";
import { verifyPassword } from "../utils/verifyPassword.js";

// SECTION ----- User operations -----
export const createUser = async (data) => {
  const { displayname, username, email, password, first_name, last_name } =
    data;
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);
  const API_KEY = await generateAPIKEY(50);
  const date = new Date();

  const query = `
    INSERT INTO users (displayname, username, email, password_hash, first_name, last_name, created_at, API_KEY)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const values = [
    displayname,
    username,
    email,
    hashedPassword,
    first_name,
    last_name,
    date,
    API_KEY,
  ];

  const [result] = await pool.query(query, values);
  const [rows] = await pool.query("SELECT * FROM users WHERE id = ?", [
    result.insertId,
  ]);
  return rows[0];
};

export const deleteUser = async (id, password) => {
  const user = await getUserById(id);
  if (!user) {
    throw new Error("User not found");
  }
  if (!(await verifyPassword(password, user.password_hash))) {
    throw new Error("Invalid password");
  }
  const query = `DELETE FROM users WHERE id = ?`;
  const Notesquery = `DELETE FROM notes WHERE id = ?`;
  const Gradesquery = `DELETE FROM grades WHERE id = ?`;
  await pool.query(Notesquery, [id]);
  await pool.query(Gradesquery, [id]);
  await pool.query(query, [id]);
};

const updateUserPassword = async (id, oldPasswordHash, newPassword) => {
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(newPassword, salt);

  if (!hashedPassword) {
    throw new Error("Password hashing failed");
  }
  if (await verifyPassword(oldPasswordHash, hashedPassword)) {
    throw new Error("New password cannot be the same as the old password");
  }

  const query = `
    UPDATE users
    SET password_hash = ?
    WHERE id = ?
    RETURNING id, displayname, username, email, first_name, last_name
  `;
  const values = [hashedPassword, id];
  const result = await pool.query(query, values);
  return result.rows[0];
};

export const loginUser = async (identifier, password) => {
  let user = await getUserByEmail(identifier);
  if (!user) {
    user = await getUserByUsername(identifier);
  }
  if (!user) {
    throw new Error("User not found");
  }

  if (!(await verifyPassword(password, user.password_hash))) {
    throw new Error("Invalid password");
  }
  return user;
};

export const updateUserProfilePicture = async (id, pfp_URL, password) => {
  const user = await getUserById(id);
  if (!user) {
    throw new Error("User not found");
  }
  if (!(await verifyPassword(password, user.password_hash))) {
    throw new Error("Invalid password");
  }
  const query = `
    UPDATE users
    SET pfp_URL = ?
    WHERE id = ?
    RETURNING pfp_URL
  `;
  const result = await pool.query(query, [pfp_URL, id]);
  return result.rows[0];
};

export const updateUserDetails = async (id, details, password) => {
  const user = await getUserById(id);
  if (!user) {
    throw new Error("User not found");
  }
  if (!(await verifyPassword(password, user.password_hash))) {
    throw new Error("Invalid password");
  }
  const fields = [];
  const values = [];
  let index = 1;
  for (const [key, value] of Object.entries(details)) {
    fields.push(`${key} = $${index}`);
    values.push(value);
    index++;
  }
  values.push(id);

  const query = `
    UPDATE users
    SET ${fields.join(", ")}
    WHERE id = $${index}
    RETURNING id, displayname, username, email, first_name, last_name
  `;
  const result = await pool.query(query, values);
  return result.rows[0];
};
// !SECTION

// SECTION ----- Public user operations -----
export const searchUsersPublic = async (searchTerm) => {
  const query = `
    SELECT id, displayname, username, email, first_name, last_name
    FROM users
    WHERE displayname LIKE ? OR username LIKE ? OR email LIKE ? OR first_name LIKE ? OR last_name LIKE ?
  `;
  const result = await pool.query(query, [
    `%${searchTerm}%`,
    `%${searchTerm}%`,
    `%${searchTerm}%`,
    `%${searchTerm}%`,
    `%${searchTerm}%`,
  ]);
  return result.rows;
};

export const getAllPublicUsers = async (lim) => {
  const query = `SELECT displayname,username,pfp_URL,created_at,email FROM users LIMIT ${lim}`;
  const [result] = await pool.query(query);
  return result;
};
// !SECTION

// SECTION ----- Admin user operations -----
export const getUserByField = async (field, value) => {
  const query = `SELECT * FROM users WHERE ${field} = ?`;
  const result = await pool.query(query, [value]);
  return result.rows[0];
};

export const searchUsersAdmin = async (searchTerm) => {
  const query = `
    SELECT id, displayname, username, email, first_name, last_name
    FROM users
    WHERE displayname LIKE ? OR username LIKE ? OR email ILIKE ? OR first_name ILIKE ? OR last_name ILIKE ?
  `;
  const result = await pool.query(query, [
    `%${searchTerm}%`,
    `%${searchTerm}%`,
    `%${searchTerm}%`,
    `%${searchTerm}%`,
    `%${searchTerm}%`,
  ]);
  return result.rows;
};

export const getUserByEmail = async (email) => {
  const [rows] = await pool.execute(`SELECT * FROM users WHERE email = (?)`, [
    email,
  ]);
  return rows[0];
};

export const getUserByUsername = async (username) => {
  const [rows] = await pool.execute(
    `SELECT * FROM users WHERE username = (?)`,
    [username]
  );
  return rows[0];
};

export const deleteUserAdmin = async (id) => {
  const query = `DELETE FROM users WHERE id = ?`;
  await pool.query(query, [id]);
};

export const getAllUsers = async () => {
  const [rows] = await pool.execute("SELECT * FROM users");
  return rows;
};

export const getUserPrivateInfoById = async (id) => {
  return getUserByField("id", id);
};

// !SECTION

export const getUserById = async (id) => {
  const [rows] = await pool.execute(`SELECT * FROM users WHERE id = (?)`, [id]);
  return rows[0];
};

export const searchUsers = async (searchTerm) => {
  const query = `
    SELECT id, displayname, username, email, first_name, last_name
    FROM users
    WHERE displayname ILIKE $1 OR username ILIKE $1 OR email ILIKE $1 OR first_name ILIKE $1 OR last_name ILIKE $1
  `;
  const result = await pool.query(query, [`%${searchTerm}%`]);
  return result.rows;
};

export const getUserPublicInfoById = async (id) => {
  const query = `
    SELECT id, displayname, username, first_name, last_name, pfp_URL
    FROM users
    WHERE id = ?
  `;
  const result = await pool.query(query, [id]);
  return result.rows[0];
};
