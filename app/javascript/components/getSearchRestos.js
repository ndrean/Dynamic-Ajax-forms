async function getSearchRestos() {
  document.querySelector("form").addEventListener("submit", async (e) => {
    e.preventDefault();
    const data = new FormData(e.target);
    const uri = new URLSearchParams(data).toString();
    console.log(uri);
    try {
      const request = await fetch("/restos?" + uri, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Accept: "application/json",
        },
      });
      const response = await request.json();
      console.log(response);
    } catch (error) {
      console.warn(error);
    }
  });
}

export { getSearchRestos };
