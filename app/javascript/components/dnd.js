import { postGenreToResto } from "./postGenreToResto";

function dragndrop() {
  document.addEventListener("dragstart", (e) => {
    // we define the data that wil lbe transfered with the dragged node
    const draggedObj = {
      idSpan: e.target.id,
      resto_id: e.target.dataset.restoId,
      //resto_name: e.target.innerText,
    };
    e.dataTransfer.effectAllowed = "move";
    /* The dataTransfer.setData() method sets the data type and the value of the dragged data
    We can only pass a string in it so we stringify the object */
    e.dataTransfer.setData("text", JSON.stringify(draggedObj));

    // we show a 'resto_name' in the select zone
    document.querySelector(
      `option[value='${draggedObj.resto_id}']`
    ).selected = true;
  });

  /* By default, data/elements cannot be dropped in other elements. 
    To allow a drop, we must prevent the default handling of the element */
  document.addEventListener("dragover", (e) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = "move";
  });

  /* On drop - Prevent the browser default handling of the data (default is open as link on drop)
    Get the dragged data with the dataTransfer.getData() method
    The dragged data is the id of the dragged element ("drag1")
    Append the dragged element into the drop element */
  document.addEventListener("drop", (e) => {
    e.preventDefault();
    // permits drop only in elt with class 'drop-zone'
    if (e.target.classList.contains("drop-zone")) {
      const transferedData = JSON.parse(e.dataTransfer.getData("text"));

      e.target.appendChild(document.getElementById(transferedData.idSpan));
      const data = {
        genre_id: e.target.parentElement.dataset.genreId,
        id: transferedData.resto_id,
      };
      console.log(data);
      postGenreToResto(data);
    }
  });
}

export { dragndrop };