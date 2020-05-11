import { csrfToken } from "@rails/ujs";

const postGenreToResto = async (obj) => {
  const headers = {
    "X-CSRF-Token": csrfToken(), //document.getElementsByName("csrf-token")[0].getAttribute("content"),
    "Content-Type": "application/json",
    Accept: "application/json",
    "X-Requested-With": "XMLHttpRequest",
  };

  const query = await fetch("post_update", {
    method: "PATCH",
    headers: headers,
    credentials: "same-origin",
    body: JSON.stringify({
      resto: {
        genre_id: obj.genre_id,
        id: obj.id,
      },
    }),
  });
  return await query.json();
};

export { postGenreToResto };
