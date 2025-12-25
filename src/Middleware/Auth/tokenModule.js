import pool from "../../config/db.js";

const table = "refresh_tokens";
export const saveRefreshToken = async (token, username) => {
  const [rows] = await pool.query(
    `INSERT INTO ${table} (username,token) VALUES (?,?)`,
    [username, token]
  );

  return rows[0];
};

export const deleteRefreshToken = async (username) => {
  await pool.query(`DELETE FROM ${table} WHERE username = (?)`, [username]);
};

export const findRefreshToken = async (username) => {
  const [result] = await pool.query(
    `SELECT * FROM ${table} WHERE username = (?)`,
    [username]
  );

  return result[0];
};

export const getAllTokens = async () => {
  const [rows] = await pool.query(`SELECT * FROM ${table}`);
  return rows;
};
