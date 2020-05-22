function displaySearchRestos() {
  document
    .querySelector("#search_for_restos")
    .addEventListener("click", (e) => {
      e.preventDefault();
      console.log("fetch restos");
      fetch("/restos", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
        },
      })
        .then((res) => res.json())
        .then((content) => {
          const [body, qstring] = content;
          console.log("result", content);
          document.querySelector(
            "#tb-restos"
          ).innerHTML = `<%= j render 'restos/trows', restos: ${body}, layout: false %>`;
          document.querySelector(
            "#paginatorRestos"
          ).innerHTML = `<%= j paginate(${body}, remote: true)%>`;
        });
    });
}

export { displaySearchRestos };
