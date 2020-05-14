import { csrfToken } from "@rails/ujs";

function updateType() {
  document
    .querySelector("#inputEditType")
    .addEventListener("click", async () => {
      console.log("update");
      //e.preventDefault();
      const name = document.querySelector("#genre_to_delete").value.trim();
      const id = document.querySelector("#hiddenId").value;
      try {
        const query = await fetch("/genres/" + id, {
          method: "PATCH",
          headers: {
            Accept: "application/json",
            "X-CSRF-Token": csrfToken(),
            "Content-Type": "application/json",
          },
          credentials: "same-origin",
          body: JSON.stringify({ genre: { id: id, name: name } }),
        });
        const response = await query.json();
        console.log(response);
        if (response.status === "ok") {
          document.querySelector(
            `[data-genre-id="${id}"] th span span`
          ).textContent = name;
          document.querySelector("#genreDeleteForm").reset();
        }
      } catch {
        (err) => console.log("impossible", err);
      }
    });
}

export { updateType };
