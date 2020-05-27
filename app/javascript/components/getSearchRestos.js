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
      return await request.json();
    } catch (error) {
      console.warn(error);
    }
  });
}

export { getSearchRestos };
