function getId() {
  document.querySelectorAll('[draggable="true"]').forEach((elt) => {
    elt.addEventListener("click", (e) => {
      const Id = e.target.dataset.restoId;
      document.querySelector(`option[value='${Id}']`).selected = true;
    });
  });
}

export { getId };
