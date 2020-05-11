import { csrfToken } from "@rails/ujs";

const postGenreToResto = async (obj = {}) => {
  try {
    const response = await fetch("/updateGenre", {
      method: "PATCH",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": csrfToken(), //document.getElementsByName("csrf-token")[0].getAttribute("content"),
        "Content-Type": "application/json",
      },
      credentials: "same-origin",
      body: JSON.stringify(obj),
    });
    return await response.json();
  } catch (err) {
    console.log(err);
  }
};

export { postGenreToResto };
