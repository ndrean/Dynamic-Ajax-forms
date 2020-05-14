import { csrfToken } from "@rails/ujs";

function updateType() {
  document.querySelector("#inputEditType").addEventListener("clic", (e) => {
    console.log("update");
    e.preventDefault();
    //   const name = document.querySelector("genre_to_delete").value;
    //   const id = document.querySelector("#hiddenId").value;
    //   try {
    //     const query = await fetch("/udpate/" + id, {
    //       method: "PATCH",
    //       headers: {
    //         Accept: "application/json",
    //         "X-CSRF-Token": csrfToken(),
    //         "Content-Type": "application/json",
    //       },
    //       credentials: "same-origin",
    //     });
    //     const response = await query.json();
    //     if (response.status === "ok") {
    //       document.querySelector(
    //         `[data-genre-id="${id}"] th span`
    //       ).innerHTML = name;
    //       document.querySelector("#genreDeleteForm").reset();
    //     }
    //   } catch {
    //     (err) => console.log("impossible", err);
    //   }
  });
}

export { updateType };
