// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("turbolinks").start();
require("channels");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import { copyActive } from "../components/copyContentEdited";
import { createComment } from "../components/createComment.js";
import { dragndrop } from "../components/dnd";
//import { postGenreToResto } from "../components/postGenreToResto";
import { listenToGenres } from "../components/listenToGenres";
import { destroyType } from "../components/fetchDelete";
import { updateType } from "../components/updateFetch";

document.addEventListener("turbolinks:load", () => {
  if (document.getElementById("tb-genres")) {
    dragndrop();
  }

  if (document.getElementById("tb-genres")) {
    listenToGenres();
    destroyType();
    updateType();
  }
  // if (document.getElementById("tb-genres")) {
  //   listenToGenres();
  //   updateType();
  // }

  const createCommentButtonNests = document.getElementById("newComment");
  if (createCommentButtonNests) {
    createComment();
  }

  if (document.querySelector("#table-restos")) {
    copyActive("#resto_name_");
  }

  if (document.querySelector("#tb-comments")) {
    copyActive("#comment_content_");
  }
});
