class NoteForm extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });
  }

  connectedCallback() {
    this.render();
    this.setupEventListeners();
  }

  setupEventListeners() {
    const form = this.shadowRoot.querySelector("form");
    const titleInput = this.shadowRoot.querySelector("#title");
    const bodyInput = this.shadowRoot.querySelector("#body");

    // Realtime validation
    titleInput.addEventListener("input", () => this.validateTitle(titleInput));
    bodyInput.addEventListener("input", () => this.validateBody(bodyInput));

    form.addEventListener("submit", (e) => {
      e.preventDefault();
      if (this.validateForm()) {
        this.dispatchEvent(
          new CustomEvent("note-added", {
            detail: {
              title: titleInput.value,
              body: bodyInput.value,
              createdAt: new Date().toISOString(),
            },
          })
        );
        form.reset();
      }
    });
  }

  validateTitle(input) {
    const errorElement = this.shadowRoot.querySelector("#title-error");
    if (input.value.length < 3) {
      errorElement.textContent = "Title must be at least 3 characters long";
      input.setCustomValidity("Title must be at least 3 characters long");
      return false;
    }
    errorElement.textContent = "";
    input.setCustomValidity("");
    return true;
  }

  validateBody(input) {
    const errorElement = this.shadowRoot.querySelector("#body-error");
    if (input.value.length < 10) {
      errorElement.textContent =
        "Note body must be at least 10 characters long";
      input.setCustomValidity("Note body must be at least 10 characters long");
      return false;
    }
    errorElement.textContent = "";
    input.setCustomValidity("");
    return true;
  }

  validateForm() {
    const titleInput = this.shadowRoot.querySelector("#title");
    const bodyInput = this.shadowRoot.querySelector("#body");
    return this.validateTitle(titleInput) && this.validateBody(bodyInput);
  }

  render() {
    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
        }

        form {
          display: grid;
          gap: 1rem;
        }

        label {
          font-weight: 500;
          color: var(--text-color);
        }

        input, textarea {
          width: 100%;
          padding: 0.75rem;
          border: 1px solid var(--border-color);
          border-radius: 4px;
          background-color: var(--background-color);
          color: var(--text-color);
          font-family: inherit;
        }

        input:focus, textarea:focus {
          outline: none;
          border-color: var(--primary-color);
        }

        textarea {
          min-height: 150px;
          resize: vertical;
        }

        button {
          background-color: var(--primary-color);
          color: white;
          border: none;
          padding: 0.75rem 1.5rem;
          border-radius: 4px;
          cursor: pointer;
          font-family: inherit;
          font-weight: 500;
          transition: background-color 0.2s;
        }

        button:hover {
          opacity: 0.9;
        }

        .error-message {
          color: var(--error-color);
          font-size: 0.875rem;
          margin-top: -0.5rem;
        }
      </style>

      <form>
        <div>
          <label for="title">Title</label>
          <input type="text" id="title" required minlength="3">
          <div id="title-error" class="error-message"></div>
        </div>

        <div>
          <label for="body">Note</label>
          <textarea id="body" required minlength="10"></textarea>
          <div id="body-error" class="error-message"></div>
        </div>

        <button type="submit">Add Note</button>
      </form>
    `;
  }
}

customElements.define("note-form", NoteForm);
