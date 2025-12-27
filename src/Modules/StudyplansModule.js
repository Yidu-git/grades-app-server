import pool from "../config/db.js";

// SECTION ----- User side studyplan operations -----
export const createStudyplan = async (data) => {
  const { studentId, planName } = data;
  const query = "INSERT INTO studyplans (student_id, plan_name) VALUES (?, ?)";
  const values = [studentId, planName];
  const [result] = await pool.query(query, values);
  const [rows] = await pool.execute("SELECT * FROM studyplans WHERE id = ?", [
    result.insertId,
  ]);
  return rows[0];
};

export const deleteStudyplan = async (studyplanId) => {
  const query = "DELETE FROM studyplans WHERE id = ?";
  await pool.query(query, [studyplanId]);
};

export const getStudyplansByStudent = async (studentId) => {
  const query = "SELECT * FROM studyplans WHERE student_id = ?";
  const [rows] = await pool.execute(query, [studentId]);
  return rows;
};

export const getStudyplanById = async (studyplanId) => {
  const query = "SELECT * FROM studyplans WHERE id = ?";
  const [rows] = await pool.execute(query, [studyplanId]);
  return rows[0];
};

export const updateStudyplanName = async (studyplanId, newName) => {
  const query = "UPDATE studyplans SET plan_name = ? WHERE id = ?";
  await pool.query(query, [newName, studyplanId]);
  const [rows] = await pool.execute("SELECT * FROM studyplans WHERE id = ?", [
    studyplanId,
  ]);
  return rows[0];
};

export const setStudyplanPublicStatus = async (studyplanId, isPublic) => {
  const query = "UPDATE studyplans SET is_public = ? WHERE id = ?";
  await pool.query(query, [isPublic, studyplanId]);
  const [rows] = await pool.execute("SELECT * FROM studyplans WHERE id = ?", [
    studyplanId,
  ]);
  return rows[0];
};

// !SECTION

// ----- Public studyplan operations -----
export const getPublicStudyplans = async (limit) => {
  const query = `SELECT * FROM studyplans WHERE is_public = true LIMIT ?`;
  const [rows] = await pool.execute(query, [limit]);
  return rows;
};

export const searchPublicStudyplansByName = async (searchTerm) => {
  const query = `
    SELECT * FROM studyplans
    WHERE is_public = true AND plan_name LIKE ?
  `;
  const result = await pool.query(query, [`%${searchTerm}%`]);
  return result.rows;
};
