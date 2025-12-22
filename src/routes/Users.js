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

const router = express.Router();
// Get ALL USERS
router.get("/", fetchAllPublicUsers);
// Get All users
router.get("/a", fetchAllUsers);
// Register
router.post("/", registerUser);
// Verification
router.post("/verify-email", verifyEmail);
// Login
router.post("/login", login);
// Get usernames
router.get("/profile/:username", getUserProfileByusername);

router.get("/profile/:id", fetchUserProfile);

router.put("/profile/:id", updateUserProfile);

router.post("/profile/:id/picture", uploadProfilePicture);

router.put("/profile/:id/password", resetPassword);

// Delete users
router.delete("/profile/:id", deleteUserAccount);
router.delete("/:id", removeUserAdmin);

export default router;
