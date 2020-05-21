/* the genres tag are made clickable with attribute 'tabindex'
On click, copies the value + id into a form (for later edit/save or delete, all JS)
*/

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
