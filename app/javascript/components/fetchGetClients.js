const fetchClients = (tag) => {
  document.querySelector(tag).addEventListener("click", async (e) => {
    e.preventDefault();
    try {
      const query = await fetch('/clients?c=""', {
        method: "GET",
        headers: {
          "Content-Type": "text/html",
          Accept: "text/html",
        },
        credentials: "same-origin", // default value
      });
      if (query.ok) {
        const content = await query.text();
        return (document.querySelector("#client_articles").innerHTML = content);
      }
    } catch (error) {
      throw error;
    }
  });
};

export { fetchClients };
