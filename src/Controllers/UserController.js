import {
  createUser,
  getUserByEmail,
  getUserByUsername,
  getUserById,
  deleteUser,
  getAllUsers,
  updateUserProfilePicture,
  updateUserDetails,
  searchUsers,
  resetUserPassword,
  getUserPrivateInfoById,
  loginUser,
  deleteUserAdmin,
  getAllPublicUsers,
} from "../Modules/UserModule.js";
// import * as JWT from "jsonwebtoken";
// const jwt = JWT;
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import {
  generateAccessToken,
  generateRefreshToken,
} from "../Middleware/Auth/AuthToken.js";
dotenv.config();

export const registerUser = async (req, res) => {
  const data = req.body;
  try {
    if (await getUserByUsername(data.username)) {
      res.status(400).json("username is already taken");
    }
    if (await getUserByEmail(data.email)) {
      res.status(400).json("email already exists");
    } else {
      const newUser = await createUser(data);
      res.status(201).json({ message: "user created" });
    }
  } catch (error) {
    res.status(500).json({
      error: "Failed to register",
      errorDetails: error.message,
    });
  }
};

export const login = async (req, res) => {
  const { identifier, password } = req.body;
  try {
    const user = await loginUser(identifier, password);
    const refresh_token = await generateRefreshToken({
      name: user.username,
      email: user.email,
    });
    const token = generateAccessToken({ name: user.username });
    res
      .status(200)
      .json({ token: token, refresh_token: refresh_token, user: user });
  } catch (error) {
    res.status(400).json({
      error: "Error while attempting to login",
      errorDetails: error.message,
      recieved: [identifier, password],
    });
  }
};

// USER PROFILE CONTROLLERS
export const fetchUserProfile = async (req, res) => {
  const userId = req.params.id;
  try {
    const user = await getUserPrivateInfoById(userId);
    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ error: "User not found" });
    }
  } catch (error) {
    res.status(500).json({
      error: "Failed to fetch user profile",
      errorDetails: error.message,
    });
  }
};

export const updateUserProfile = async (req, res) => {
  const userId = req.params.id;
  const updates = req.body;
  try {
    const updatedUser = await updateUserDetails(userId, updates);
    res.status(200).json(updatedUser);
  } catch (error) {
    res.status(500).json({
      error: "Failed to update user profile",
      errorDetails: error.message,
    });
  }
};

export const uploadProfilePicture = async (req, res) => {
  const userId = req.params.id;
  const { pfp_URL } = req.body;
  try {
    const updatedUser = await updateUserProfilePicture(userId, pfp_URL);
    res.status(200).json(updatedUser);
  } catch (error) {
    res.status(500).json({
      error: "Failed to update user profile picture",
      errorDetails: error.message,
    });
  }
};

// ADMIN CONTROLLERS
export const fetchAllUsers = async (req, res) => {
  try {
    const user = req.user;
    // if (user.role === "admin") {
    //ADD check if user exists
    const users = await getAllUsers();
    res.status(200).json(users);
    // } else res.status(403);
  } catch (error) {
    res
      .status(400)
      .json({ error: "Failed to fetch users", message: error.message });
    // res.status(200).json(users);
  }
};

export const deleteUserAccount = async (req, res) => {
  const username = req.params.username;
  const user = await getUserByUsername(username);
  try {
    const { password } = req.body;
    if (user) {
      await deleteUser(user.id, password, user.password_hash);
      res.status(200).json({ message: "User deleted successfully" });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    res.status(400).json({
      error: "Failed to delete user",
      errorDetails: error.message,
    });
  }
};
export const searchForUsers = async (req, res) => {
  const { query } = req.query;
  try {
    const users = await searchUsers(query);
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({
      error: "Failed to search users",
      errorDetails: error.message,
    });
  }
};

// PASSWORD CONTROLLERS
export const resetPassword = async (req, res) => {
  const { id, newPassword } = req.body;
  try {
    const updatedUser = await resetUserPassword(id, newPassword);
    res.status(200).json(updatedUser);
  } catch (error) {
    res.status(500).json({
      error: "Failed to reset password",
      errorDetails: error.message,
    });
  }
};
export const fetchAllPublicUsers = async (req, res) => {
  try {
    const limit = req.params.limit;
    const users = await getAllPublicUsers(limit);
    res.status(200).json(users);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Secutity
export const genrate_verification_code = async () => {
  const code = Math.floor(100000 + Math.random() * 900000).toString();
  return code;
};

export const searchUsersByUsername = async (searchTerm) => {
  const query = `
    SELECT id, displayname, username, email, first_name, last_name
    FROM users
    WHERE username ILIKE $1
  `;
  const result = await pool.query(query, [`%${searchTerm}%`]);
  return result.rows;
};

export const searchUsersByEmail = async (searchTerm) => {
  const query = `
    SELECT id, displayname, username, email, first_name, last_name
    FROM users
    WHERE email ILIKE $1
  `;
  const result = await pool.query(query, [`%${searchTerm}%`]);
  return result.rows;
};
export const searchUsersByDisplayName = async (searchTerm) => {
  const query = `
    SELECT id, displayname, username, email, first_name, last_name
    FROM users
    WHERE displayname ILIKE $1
  `;
  const result = await pool.query(query, [
    `
    %${searchTerm}%`,
  ]);
  return result.rows;
};

export const removeUserAdmin = async (req, res) => {
  const id = req.params.id;
  try {
    const user = await getUserById(id);
    await deleteUserAdmin(id);
    if (user) {
      res.status(200).json({ message: "User deleted successfully" });
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    res.status(500).json({
      error: "Error deleting user",
      errorDetails: error.message,
      params: id,
    });
  }
};

export const getUserProfileByusername = async (req, res) => {
  const username = req.params.username;
  try {
    const user = await getUserByUsername(username);
    if (user) {
      // res.status(200).json({
      //   message: "User found",
      //   recieved: username,
      //   user: user,
      // });
      res.status(200).json(user);
    } else {
      res.status(404).json({ message: "User not found" });
    }
  } catch (error) {
    res.status(500).json({
      error: "Error while searching",
      errorDetails: [error.message, error],
      params: req.params,
    });
  }
};

export const fetchUserByID = async (req, res) => {
  const id = res.params.id;
  try {
    const user = await getUserById(id);
    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404);
    }
  } catch (error) {
    res.status(500).json({
      error: "Error while searching",
      errorDetails: error.message,
      params: req.params,
    });
  }
};
