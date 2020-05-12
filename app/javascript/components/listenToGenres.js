function listenToGenres() {
  document.querySelector("#tb-genres").addEventListener("click", () => {
    const item = document.activeElement;
    if (item.classList.contains("genre_tag")) {
      document.querySelector("#hiddenId").value =
        item.parentElement.parentElement.dataset.genreId;
      document.querySelector("#genre_to_delete").value = item.textContent;
    }
  });
}

export { listenToGenres };
