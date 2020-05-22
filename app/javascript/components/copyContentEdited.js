const copyActive = (tag) => {
  document.querySelectorAll("td").forEach((td) => {
    td.addEventListener("input", (e) => {
      console.log("found", td);
      const id = e.target.dataset.editable;
      document.querySelector(tag + id).value = e.target.innerText;
    });
  });
};

export { copyActive };
