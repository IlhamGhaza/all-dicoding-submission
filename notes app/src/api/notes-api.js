const BASE_URL = "https://notes-api.dicoding.dev/v2";

class NotesApi {
  static async getNotes() {
    try {
      console.log("Fetching notes...");
      const response = await fetch(`${BASE_URL}/notes`);
      const responseJson = await response.json();
      console.log("API Response:", responseJson);

      if (responseJson.status !== "success") {
        throw new Error(responseJson.message || "Failed to fetch notes");
      }

      return responseJson.data;
    } catch (error) {
      console.error("Error fetching notes:", error);
      throw new Error(`Failed to fetch notes: ${error.message}`);
    }
  }

  static async addNote({ title, body }) {
    try {
      console.log("Adding note:", { title, body });
      const response = await fetch(`${BASE_URL}/notes`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ title, body }),
      });

      const responseJson = await response.json();
      console.log("Add note response:", responseJson);

      if (responseJson.status !== "success") {
        throw new Error(responseJson.message || "Failed to add note");
      }

      return responseJson.data;
    } catch (error) {
      console.error("Error adding note:", error);
      throw new Error(`Failed to add note: ${error.message}`);
    }
  }

  static async deleteNote(id) {
    try {
      console.log("Deleting note:", id);
      const response = await fetch(`${BASE_URL}/notes/${id}`, {
        method: "DELETE",
      });

      const responseJson = await response.json();
      console.log("Delete note response:", responseJson);

      if (responseJson.status !== "success") {
        throw new Error(responseJson.message || "Failed to delete note");
      }

      return responseJson.data;
    } catch (error) {
      console.error("Error deleting note:", error);
      throw new Error(`Failed to delete note: ${error.message}`);
    }
  }

  static async archiveNote(id) {
    try {
      console.log("Archiving note:", id);
      const response = await fetch(`${BASE_URL}/notes/${id}/archive`, {
        method: "POST",
      });

      const responseJson = await response.json();
      console.log("Archive note response:", responseJson);

      if (responseJson.status !== "success") {
        throw new Error(responseJson.message || "Failed to archive note");
      }

      return responseJson.data;
    } catch (error) {
      console.error("Error archiving note:", error);
      throw new Error(`Failed to archive note: ${error.message}`);
    }
  }

  static async unarchiveNote(id) {
    try {
      console.log("Unarchiving note:", id);
      const response = await fetch(`${BASE_URL}/notes/${id}/unarchive`, {
        method: "POST",
      });

      const responseJson = await response.json();
      console.log("Unarchive note response:", responseJson);

      if (responseJson.status !== "success") {
        throw new Error(responseJson.message || "Failed to unarchive note");
      }

      return responseJson.data;
    } catch (error) {
      console.error("Error unarchiving note:", error);
      throw new Error(`Failed to unarchive note: ${error.message}`);
    }
  }

  static async getArchivedNotes() {
    try {
      console.log("Fetching archived notes...");
      const response = await fetch(`${BASE_URL}/notes/archived`);
      const responseJson = await response.json();

      if (responseJson.status !== "success") {
        throw new Error(responseJson.message || "Failed to fetch archived notes");
      }

      return responseJson.data;
    } catch (error) {
      console.error("Error fetching archived notes:", error);
      throw new Error(`Failed to fetch archived notes: ${error.message}`);
    }
  }

  static async getAllNotes() {
    try {
      const [active, archived] = await Promise.all([
        this.getNotes(),
        this.getArchivedNotes(),
      ]);
      return [...active, ...archived];
    } catch (error) {
      throw error;
    }
  }
}

export default NotesApi;
