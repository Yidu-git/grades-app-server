import pool from "../config/db.js";
import bcrypt from "bcryptjs";

export const genrate_verification_code = async (length = 6) => {
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let verification_code = "";

  for (let i = 0; i < length; i++) {
    verification_code += characters.charAt(
      Math.floor(Math.random() * characters.length)
    );
  }

  return verification_code;
};

export const generateAPIKEY = async (length = 20) => {
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789$%&";
  let API_KEY = "";

  for (let i = 0; i < length; i++) {
    API_KEY += characters.charAt(Math.floor(Math.random() * characters.length));
  }

  return API_KEY;
};

const verifyPassword = async (password, hash) => {
  return bcrypt.compare(password, hash);
};

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

export const verifyUserEmail = async (email, verificationCode) => {
  const query = `UPDATE users SET is_verified = true WHERE email = ? AND verification_code = ?`;
  await pool.query(query, [email, verificationCode]);
};

const getUserByField = async (field, value) => {
  const query = `SELECT * FROM users WHERE ${field} = ?`;
  const result = await pool.query(query, [value]);
  return result.rows[0];
};

const getPublicInfoByField = async (field, value) => {
  const query = `SELECT * FROM users WHERE ${field} = ?`;
  const result = await pool.query(query, [value]);
  return result.rows[0];
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

export const getUserById = async (id) => {
  const [rows] = await pool.execute(`SELECT * FROM users WHERE id = (?)`, [id]);
  return rows[0];
};

const updateUserPassword = async (id, newPassword) => {
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(newPassword, salt);

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

export const deleteUser = async (id, passwordHash) => {
  const user = await getUserById(id);
  if (!user) {
    throw new Error("User not found");
  }
  const isPasswordValid = await bcrypt.compare(
    passwordHash,
    user.password_hash
  );
  if (!isPasswordValid) {
    throw new Error("Invalid password");
  }
  const query = `DELETE FROM users WHERE id = ?`;
  await pool.query(query, [id]);
};

export const deleteUserAdmin = async (id) => {
  const query = `DELETE FROM users WHERE id = ?`;
  await pool.query(query, [id]);
};

export const getAllUsers = async () => {
  const [rows] = await pool.execute("SELECT * FROM users");
  return rows;
};

export const updateUserProfilePicture = async (id, pfp_URL) => {
  const query = `
    UPDATE users
    SET pfp_URL = ?
    WHERE id = ?
    RETURNING id, displayname, username, email, first_name, last_name, pfp_URL
  `;
  const result = await pool.query(query, [pfp_URL, id]);
  return result.rows[0];
};

export const updateUserDetails = async (id, details, passwordHash) => {
  const user = await getUserById(id);
  if (!user) {
    throw new Error("User not found");
  }
  const isPasswordValid = await bcrypt.compare(
    passwordHash,
    user.password_hash
  );
  if (!isPasswordValid) {
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

export const searchUsers = async (searchTerm) => {
  const query = `
    SELECT id, displayname, username, email, first_name, last_name
    FROM users
    WHERE displayname ILIKE $1 OR username ILIKE $1 OR email ILIKE $1 OR first_name ILIKE $1 OR last_name ILIKE $1
  `;
  const result = await pool.query(query, [`%${searchTerm}%`]);
  return result.rows;
};

export const resetUserPassword = async (email, newPassword, passwordHash) => {
  const user = await getUserByEmail(email);
  if (!user) {
    throw new Error("User not found");
  }
  const isPasswordValid = await bcrypt.compare(
    passwordHash,
    user.password_hash
  );
  if (!isPasswordValid) {
    throw new Error("Invalid password");
  }
  return updateUserPassword(user.id, newPassword);
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

export const getUserPrivateInfoById = async (id) => {
  return getUserByField("id", id);
};

export const loginUser = async (identifier, password) => {
  let user = await getUserByEmail(identifier);
  if (!user) {
    user = await getUserByUsername(identifier);
  }
  if (!user) {
    throw new Error("User not found");
  }
  const isPasswordValid = await bcrypt.compare(password, user.password_hash);
  if (!isPasswordValid) {
    throw new Error("Invalid password");
  }
  return user;
};
