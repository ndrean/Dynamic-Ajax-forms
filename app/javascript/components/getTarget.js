function getId() {
  document.querySelectorAll('[draggable="true"]').forEach((elt) => {
    elt.addEventListener("click", (e) => {
      const id = e.target.dataset.restoId;
      const restoName = e.target.innerText;
      console.log("getID :", id, restoName);
      document.querySelector(`option[value='${id}']`).selected = true;
    });
  });
}

export { getId };
