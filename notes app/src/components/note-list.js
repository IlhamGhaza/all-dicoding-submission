class NoteList extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });
    this.notes = [];
    this.isLoading = false;
    this.currentTab = "active"; // new state for tab selection
  }

  static get observedAttributes() {
    return ["loading"];
  }

  connectedCallback() {
    console.log("NoteList connected");
    this.render();
  }

  attributeChangedCallback(name, oldValue, newValue) {
    console.log("NoteList attribute changed:", { name, oldValue, newValue });
    if (name === "loading") {
      this.isLoading = newValue === "true";
      this.render();
    }
  }

  setNotes(notes) {
    console.log("Setting notes:", notes);
    this.notes = notes;
    this.render();
  }

  render() {
    console.log("Rendering NoteList:", {
      notes: this.notes,
      isLoading: this.isLoading,
      currentTab: this.currentTab,
    });
    const activeNotes = this.notes.filter((note) => !note.archived);
    const archivedNotes = this.notes.filter((note) => note.archived);

    // choose which notes to show based on current tab
    const visibleNotes =
      this.currentTab === "active" ? activeNotes : archivedNotes;

    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
        }

        .tabs {
          display: flex;
          gap: 1rem;
          margin-bottom: 1rem;
        }

        .tab-btn {
          padding: 0.5rem 1rem;
          border: none;
          background-color: var(--card-background);
          color: var(--text-color);
          border-radius: 4px;
          cursor: pointer;
          font-family: inherit;
          transition: background-color 0.2s, color 0.2s;
        }

        .tab-btn.active {
          background-color: var(--primary-color);
          color: white;
        }

        .notes-grid {
          display: grid;
          grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
          gap: 1.5rem;
          padding: 1rem 0;
        }

        .empty-state {
          text-align: center;
          padding: 2rem;
          color: var(--text-color);
          opacity: 0.7;
        }

        @media (max-width: 768px) {
          .notes-grid {
            grid-template-columns: 1fr;
          }
        }
      </style>

      <div class="tabs">
        <button class="tab-btn ${
          this.currentTab === "active" ? "active" : ""
        }" data-tab="active">Active</button>
        <button class="tab-btn ${
          this.currentTab === "archived" ? "active" : ""
        }" data-tab="archived">Archived</button>
      </div>

      ${
        this.isLoading
          ? "<loading-spinner></loading-spinner>"
          : `
        <div class="notes-grid">
          ${
            visibleNotes.length > 0
              ? visibleNotes
                  .map(
                    (note) => `
            <note-item
              id="${note.id}"
              title="${note.title}"
              body="${note.body}"
              created-at="${note.createdAt}"
              archived="${note.archived}"
            ></note-item>
          `
                  )
                  .join("")
              : `<div class="empty-state">No ${
                  this.currentTab === "active" ? "active" : "archived"
                } notes</div>`
          }
        </div>
      `
      }
    `;

    // Add event listeners for tab buttons
    this.shadowRoot.querySelectorAll(".tab-btn").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        const tab = e.target.dataset.tab;
        if (tab && tab !== this.currentTab) {
          this.currentTab = tab;
          this.render();
        }
      });
    });

    // Add event listeners for note actions
    this.shadowRoot.querySelectorAll("note-item").forEach((noteItem) => {
      noteItem.addEventListener("archive-toggle", (e) => {
        console.log("Note item archive toggle:", e.detail);
        this.dispatchEvent(
          new CustomEvent("archive-toggle", {
            detail: e.detail,
          })
        );
      });

      noteItem.addEventListener("delete-note", (e) => {
        console.log("Note item delete:", e.detail);
        this.dispatchEvent(
          new CustomEvent("delete-note", {
            detail: e.detail,
          })
        );
      });
    });
  }
}

customElements.define("note-list", NoteList);
