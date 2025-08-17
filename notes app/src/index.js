import "./components/note-item.js";
import "./components/note-list.js";
import "./components/note-form.js";
import "./components/loading-spinner.js";
import "./components/toast-notification.js";
import NotesApi from "./api/notes-api.js";
import "./styles/main.css";

class NotesApp {
  constructor() {
    console.log("Initializing NotesApp...");
    this.notes = [];
    this.noteList = document.querySelector("note-list");
    this.noteForm = document.querySelector("note-form");

    if (!this.noteList || !this.noteForm) {
      console.error("Required elements not found:", {
        noteList: !!this.noteList,
        noteForm: !!this.noteForm,
      });
      return;
    }

    this.init();
  }

  async init() {
    try {
      console.log("Starting app initialization...");
      this.setLoading(true);
      this.notes = await NotesApi.getAllNotes();
      console.log("Notes loaded:", this.notes);
      this.noteList.setNotes(this.notes);
    } catch (error) {
      console.error("Error during initialization:", error);
      this.showToast(error.message, "error");
    } finally {
      this.setLoading(false);
    }

    this.setupEventListeners();
  }

  setupEventListeners() {
    console.log("Setting up event listeners...");

    // Handle new note creation
    this.noteForm.addEventListener("note-added", async (e) => {
      console.log("Note added event:", e.detail);
      try {
        this.setLoading(true);
        const newNote = await NotesApi.addNote(e.detail);
        console.log("New note created:", newNote);
        this.notes = await NotesApi.getAllNotes();
        this.noteList.setNotes(this.notes);
        this.showToast("Note added successfully!", "success");
      } catch (error) {
        console.error("Error adding note:", error);
        this.showToast(error.message, "error");
      } finally {
        this.setLoading(false);
      }
    });

    // Handle note archiving
    this.noteList.addEventListener("archive-toggle", async (e) => {
      const { id, isArchived } = e.detail;
      console.log("Archive toggle event:", { id, isArchived });
      try {
        this.setLoading(true);
        if (isArchived) {
          await NotesApi.unarchiveNote(id);
        } else {
          await NotesApi.archiveNote(id);
        }
        this.notes = await NotesApi.getAllNotes();
        this.noteList.setNotes(this.notes);
        this.showToast(
          `Note ${isArchived ? "unarchived" : "archived"} successfully!`,
          "success"
        );
      } catch (error) {
        console.error("Error toggling archive:", error);
        this.showToast(error.message, "error");
      } finally {
        this.setLoading(false);
      }
    });

    // Handle note deletion
    this.noteList.addEventListener("delete-note", async (e) => {
      const { id } = e.detail;
      console.log("Delete note event:", id);
      try {
        this.setLoading(true);
        await NotesApi.deleteNote(id);
        this.notes = await NotesApi.getAllNotes();
        this.noteList.setNotes(this.notes);
        this.showToast("Note deleted successfully!", "success");
      } catch (error) {
        console.error("Error deleting note:", error);
        this.showToast(error.message, "error");
      } finally {
        this.setLoading(false);
      }
    });
  }

  setLoading(isLoading) {
    console.log("Setting loading state:", isLoading);
    if (isLoading) {
      this.noteList.setAttribute("loading", "true");
    } else {
      this.noteList.removeAttribute("loading");
    }
  }

  showToast(message, type = "error") {
    console.log("Showing toast:", { message, type });
    const toast = document.createElement("toast-notification");
    toast.setAttribute("message", message);
    toast.setAttribute("type", type);
    document.body.appendChild(toast);
  }
}

// Initialize the app when the DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  console.log("DOM loaded, initializing app...");
  new NotesApp();
});
