import {
  getNotes,
  getPublicNotes,
  deleteNote,
  createNote,
  editNote,
  findNote,
} from "../Modules/NotesModule.js";

export const fetchNotes = async (req, res) => {
  try {
    const limit = req.params.limit;
    const user = req.user;
    const notes = await getNotes(user, limit);
    res.status(200).json(notes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const fetchPublicNotes = async (req, res) => {
  try {
    const limit = req.params.limit;
    const notes = await getPublicNotes(limit);
    res.status(200).json(notes);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export const postNote = async (req, res) => {
  try {
    const data = req.body;
    const createdNote = await createNote(data);
    res.status(200).json({ createdNote });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const DeleteNote = async (req, res) => {
  try {
    const id = req.params.id;
    if (await findNote(id)) {
      await deleteNote(id);
      res.status(200).json("Note deleted successfully");
    } else {
      res.status(404).json("Note not found");
    }
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

export const EditNote = async (req, res) => {
  try {
    const data = req.body;
    const id = req.params;
    const editedNote = editNote(id, data);
    res.status(200).json(editedNote);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};
