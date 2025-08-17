class ToastNotification extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });
  }

  static get observedAttributes() {
    return ["message", "type"];
  }

  connectedCallback() {
    this.render();
    this.setupAutoHide();
  }

  attributeChangedCallback(name, oldValue, newValue) {
    if (oldValue !== newValue) {
      this.render();
      this.setupAutoHide();
    }
  }

  setupAutoHide() {
    setTimeout(() => {
      this.remove();
    }, 3000);
  }

  render() {
    const message = this.getAttribute("message") || "";
    const type = this.getAttribute("type") || "error";

    this.shadowRoot.innerHTML = `
      <style>
        :host {
          position: fixed;
          bottom: 20px;
          right: 20px;
          z-index: 1000;
          animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
          from {
            transform: translateX(100%);
            opacity: 0;
          }
          to {
            transform: translateX(0);
            opacity: 1;
          }
        }

        .toast {
          padding: 1rem 1.5rem;
          border-radius: 4px;
          background-color: var(--background-color);
          color: var(--text-color);
          box-shadow: var(--shadow);
          display: flex;
          align-items: center;
          gap: 0.5rem;
          min-width: 300px;
        }

        .toast.error {
          border-left: 4px solid var(--error-color);
        }

        .toast.success {
          border-left: 4px solid var(--success-color);
        }

        .icon {
          font-size: 1.25rem;
        }

        .message {
          flex: 1;
        }
      </style>

      <div class="toast ${type}">
        <span class="icon">${type === "error" ? "⚠️" : "✅"}</span>
        <span class="message">${message}</span>
      </div>
    `;
  }
}

customElements.define("toast-notification", ToastNotification);
