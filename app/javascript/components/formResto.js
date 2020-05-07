// define the class
class formResto extends HTMLElement {
  /* if we change the constructor, then we have to use 'super'
  otherwise you just don't define it.

  constructor() {
    super();
  }
  */
  /* the 'connectedCallback' will be called by each web-component '<formResto>'detected. */
  connectedCallback() {
    const shadowRoot = this.attachShadow({ mode: "open" });
    // this is a documentFragment
    const formTemplate = document.querySelector("#form-resto-template");
    // you need to clone it as it can be used only once, and append it to the shadowRoot
    shadowRoot.appendChild(formTemplate.content.cloneNode(true));
    console.log("Copy of Form inserted into DOM");

    // get the attributes of the web-component
    formTemplate;
  }

  disconnectedCallback() {
    console.log("Todo removed from DOM");
  }
}

window.customElements.define("form-resto", FormResto);
