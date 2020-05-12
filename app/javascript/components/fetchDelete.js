import { csrfToken } from "@rails/ujs";

function destroyType() {
  document
    .querySelector("#genreDeleteForm")
    .addEventListener("submit", async (e) => {
      e.preventDefault();
      const id = document.querySelector("#hiddenId").value;
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
        if (response.status !== "ok") {
          window.alert(response.status);
          document.querySelector("#genre_to_delete").value = "Not permitted";
        }
      } catch {
        (err) => console.log("impossible", err);
      }
    });
}

export { destroyType };
