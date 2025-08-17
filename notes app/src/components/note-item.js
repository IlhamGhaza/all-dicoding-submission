class NoteItem extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });
  }

  static get observedAttributes() {
    return ["title", "body", "created-at", "archived", "id"];
  }

  connectedCallback() {
    this.render();
    this.setupEventListeners();
  }

  attributeChangedCallback() {
    this.render();
    this.setupEventListeners();
  }

  setupEventListeners() {
    const archiveButton = this.shadowRoot.querySelector(".archive-btn");
    const deleteButton = this.shadowRoot.querySelector(".delete-btn");

    if (archiveButton) {
      archiveButton.addEventListener("click", () => {
        const id = this.getAttribute("id");
        const isArchived = this.getAttribute("archived") === "true";

        this.dispatchEvent(
          new CustomEvent("archive-toggle", {
            detail: { id, isArchived },
          })
        );
      });
    }

    if (deleteButton) {
      deleteButton.addEventListener("click", () => {
        const id = this.getAttribute("id");
        this.dispatchEvent(
          new CustomEvent("delete-note", {
            detail: { id },
          })
        );
      });
    }
  }

  formatDate(dateString) {
    const options = {
      year: "numeric",
      month: "long",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    };
    return new Date(dateString).toLocaleDateString("en-US", options);
  }

  render() {
    const title = this.getAttribute("title") || "";
    const body = this.getAttribute("body") || "";
    const createdAt = this.getAttribute("created-at") || "";
    const isArchived = this.getAttribute("archived") === "true";

    const truncatedBody =
      body.length > 150 ? body.substring(0, 150) + "..." : body;

    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
          background-color: var(--card-background);
          padding: 1.5rem;
          border-radius: 8px;
          box-shadow: var(--shadow);
          margin-bottom: 1rem;
          transition: transform 0.2s, opacity 0.2s;
        }

        :host(:hover) {
          transform: translateY(-2px);
        }

        .note-title {
          font-size: 1.25rem;
          font-weight: 600;
          margin-bottom: 0.5rem;
          color: var(--text-color);
        }

        .note-body {
          color: var(--text-color);
          margin-bottom: 1rem;
          line-height: 1.5;
        }

        .note-date {
          font-size: 0.875rem;
          color: var(--text-color);
          opacity: 0.7;
          margin-bottom: 1rem;
        }

        .note-actions {
          display: flex;
          gap: 0.5rem;
        }

        button {
          padding: 0.5rem 1rem;
          border: none;
          border-radius: 4px;
          cursor: pointer;
          font-family: inherit;
          font-size: 0.875rem;
          transition: opacity 0.2s;
        }

        button:hover {
          opacity: 0.8;
        }

        .archive-btn {
          background-color: var(--primary-color);
          color: white;
        }

        .delete-btn {
          background-color: var(--error-color);
          color: white;
        }

        .archived-badge {
          display: inline-block;
          padding: 0.25rem 0.5rem;
          background-color: var(--primary-color);
          color: white;
          border-radius: 4px;
          font-size: 0.75rem;
          margin-left: 0.5rem;
        }
      </style>

      <div class="note-title">
        ${title}
        ${isArchived ? '<span class="archived-badge">Archived</span>' : ""}
      </div>
      <div class="note-body">${truncatedBody}</div>
      <div class="note-date">${this.formatDate(createdAt)}</div>
      <div class="note-actions">
        <button class="archive-btn">
          ${isArchived ? "Unarchive" : "Archive"}
        </button>
        <button class="delete-btn">Delete</button>
      </div>
    `;
  }
}

customElements.define("note-item", NoteItem);
