import express from "express";
import {
  fetchAllUsers,
  fetchAllPublicUsers,
  registerUser,
  verifyEmail,
  login,
  fetchUserProfile,
  getUserProfileByusername,
  updateUserProfile,
  uploadProfilePicture,
  resetPassword,
  deleteUserAccount,
  removeUserAdmin,
} from "../Controllers/UserController.js";
import {
  AuthToken,
  fetchAllTokens,
  generateToken,
} from "../Middleware/Auth/AuthToken.js";

const router = express.Router();

// Public info
router.get("/all/:limit", fetchAllPublicUsers);

// Admin
router.get("/a", fetchAllUsers);
router.get("/profile/:username", getUserProfileByusername);
router.delete("/:id", removeUserAdmin);

// User specific
router.put("/profile/:id", updateUserProfile);
router.get("/profile/:id", fetchUserProfile);
router.post("/profile/:id/picture", uploadProfilePicture);
router.put("/profile/:id/password", resetPassword);
router.delete("/profile/:username", deleteUserAccount);

export default router;
