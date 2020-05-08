function $(tag) {
  return document.querySelector(tag);
}

const copyActive = (tag) => {
  document.querySelectorAll("td").forEach((td) => {
    td.addEventListener("input", (e) => {
      const id = e.target.dataset.editable;
      document.querySelector(tag + id).value = e.target.innerText;
    });
  });
};

export { copyActive };
