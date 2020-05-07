function createComment() {
  const createCommentButton = document.getElementById("newComment");
  createCommentButton.addEventListener("click", (e) => {
    e.preventDefault();
    const arrayComments = [...document.querySelectorAll(".fieldComment")];
    const lastId = arrayComments[arrayComments.length - 1];
    const newId = parseInt(lastId.dataset.id, 10) + 1;

    document.querySelector("#commentsDiv").insertAdjacentHTML(
      "beforeend",
      `<fieldset class="form-group pl-1 fieldComment" data-id="${newId}">
          <label  for="resto_comments_attributes_${newId}_Comment:">Comment:</label>
          <input type="text" name="resto[comments_attributes][${newId}][comment]" required="required">
        </fieldset>`
    );
  });
}

export { createComment };
