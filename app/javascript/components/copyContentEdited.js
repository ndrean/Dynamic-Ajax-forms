const copyActive = (tag) => {
  document.body.addEventListener("input", (e) => console.log(e.target));
  document.querySelectorAll("td").forEach((td) => {
    document.body.addEventListener("input", (e) => {
      console.log("found", td);
      const id = e.target.dataset.editable;
      document.querySelector(tag + id).value = e.target.innerText;
    });
  });
};

export { copyActive };
