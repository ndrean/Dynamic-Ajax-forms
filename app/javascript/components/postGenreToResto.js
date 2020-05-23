import { csrfToken } from "@rails/ujs";

// used by dnd (drag & drop), served by restos#updateGenre endpoint to update resto.genre after drag
const postGenreToResto = async (obj = {}) => {
  try {
    const response = await fetch("/updateGenre", {
      method: "PATCH",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": csrfToken(), // for CORS as we want to prevent from internal interceptions
        "Content-Type": "application/json",
      },
      credentials: "same-origin", //if authentification with cookie
      body: JSON.stringify(obj),
    });
    return await response.json();
  } catch (err) {
    console.log(err);
  }
};

export { postGenreToResto };
