import { csrfToken } from "@rails/ujs";

function destroyType() {
  document
    .querySelector("#genreDeleteForm")
    .addEventListener("submit", async (e) => {
      e.preventDefault();
      const id = document.querySelector("#hiddenId").value;
      console.log(id);
      try {
        const query = await fetch("/deleteFetch/" + id, {
          method: "DELETE",
          headers: {
            Accept: "application/json",
            "X-CSRF-Token": csrfToken(),
            "Content-Type": "application/json",
          },
          credentials: "same-origin",
        });
        const response = await query.json();
        if (response.status === "ok") {
          document.querySelector(`[data-genre-id="${id}"]`).remove();
          document.querySelector("#genreDeleteForm").reset();
        }
      } catch {
        (err) => console.log("impossible", err);
      }
    });
}

export { destroyType };
