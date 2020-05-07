function $(tag) {
  return document.querySelector(tag);
}

const copyActive = () => {
  document.querySelectorAll("td").forEach((td) => {
    td.addEventListener("input", (e) => {
      const id = e.target.dataset.editable;
      $("#resto_name_" + id).value = e.target.innerText;
    });
  });
};

export { copyActive };
