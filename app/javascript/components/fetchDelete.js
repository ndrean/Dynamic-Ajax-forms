import { csrfToken } from "@rails/ujs";

/* on click on submit, reads a form, calls the genres#deleteFetch endpoint for destroy
 */
function destroyType() {
  document
    .querySelector("#genreDeleteForm")
    .addEventListener("submit", async (e) => {
      console.log("destroy via fetch()");
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
      } catch {
        (err) => console.log("impossible", err);
      }
    });
}

export { destroyType };
