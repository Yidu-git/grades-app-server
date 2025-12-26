import express from "express";
import {
  fetchNotes,
  fetchPublicNotes,
  postNote,
  DeleteNote,
  EditNote,
} from "../Controllers/NoteController.js"; // Corrected import path
import { AuthToken } from "../Middleware/Auth/AuthToken.js";

const router = express.Router();

router.get("/profile/:limit", fetchNotes);
router.get("/all/:limit", fetchPublicNotes);
router.post("/post", postNote);
router.delete("/:id", DeleteNote);
router.post("/edit/:id", EditNote);

export default router;
