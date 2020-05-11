const dragndrop = () => {
  document.addEventListener("dragstart", (e) => {
    const draggedObj = {
      idSpan: e.target.id,
      resto_id: e.target.dataset.restoId,
      resto_name: e.target.innerText,
    };
    /* The dataTransfer.setData() method sets the data type and the value of the dragged data
    We can only pass a string in it so we stringify the object */
    e.dataTransfer.setData("Text", JSON.stringify(draggedObj));
    console.log("Started to drag the p element.");

    // we show a 'resto_name' in the select zone
    document.querySelector(
      `option[value='${draggedObj.resto_id}']`
    ).selected = true;
  });

  //   document.addEventListener("dragend", () => {
  //     console.log("Finished dragging the p element.");
  //   });

  /* By default, data/elements cannot be dropped in other elements. 
    To allow a drop, we must prevent the default handling of the element */
  document.addEventListener("dragover", (e) => {
    e.preventDefault();
  });

  /* On drop - Prevent the browser default handling of the data (default is open as link on drop)
    Get the dragged data with the dataTransfer.getData() method
    The dragged data is the id of the dragged element ("drag1")
    Append the dragged element into the drop element */
  document.addEventListener("drop", (e) => {
    e.preventDefault();
    // permits drop only in elt with class 'drop-zone'
    if (e.target.classList.contains("drop-zone")) {
      const { idSpan, resto_id, resto_name } = JSON.parse(
        e.dataTransfer.getData("Text")
      );
      e.target.appendChild(document.getElementById(idSpan));
      e.dataTransfer.clearData();
    }
  });
};

export { dragndrop };
