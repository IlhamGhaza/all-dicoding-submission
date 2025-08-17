class LoadingSpinner extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: "open" });
  }

  connectedCallback() {
    this.render();
  }

  render() {
    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: inline-block;
        }

        .spinner {
          width: 40px;
          height: 40px;
          border: 4px solid var(--border-color);
          border-top: 4px solid var(--primary-color);
          border-radius: 50%;
          animation: spin 1s linear infinite;
        }

        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }

        .overlay {
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background-color: rgba(0, 0, 0, 0.5);
          display: flex;
          justify-content: center;
          align-items: center;
          z-index: 1000;
        }

        .spinner-container {
          background-color: var(--background-color);
          padding: 2rem;
          border-radius: 8px;
          box-shadow: var(--shadow);
          text-align: center;
        }

        .spinner-text {
          margin-top: 1rem;
          color: var(--text-color);
          font-size: 0.875rem;
        }
      </style>

      <div class="overlay">
        <div class="spinner-container">
          <div class="spinner"></div>
          <div class="spinner-text">Loading...</div>
        </div>
      </div>
    `;
  }
}

customElements.define("loading-spinner", LoadingSpinner);
