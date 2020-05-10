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
import { getId } from "../components/getTarget";

document.addEventListener("turbolinks:load", () => {
  if (document.getElementById("tb-genres")) {
    getId();
  }

  const createCommentButtonNests = document.getElementById("newComment");
  console.group("loaded");
  if (createCommentButtonNests) {
    createComment();
  }

  if (document.querySelector("#table-restos")) {
    console.log("looking");
    copyActive("#resto_name_");
  }

  if (document.querySelector("#tb-comments")) {
    copyActive("#comment_content_");
  }

  function dragstart_handler(ev) {
    // Add the target element's id to the data transfer object
    ev.dataTransfer.setData("text/HTML", ev.target.id);
  }

  function drop_handler(ev) {
    ev.preventDefault();
    // Get the id of the target and add the moved element to the target's DOM
    const data = ev.dataTransfer.getData("text/HTML");
    ev.target.appendChild(document.getElementById(data));
  }
  window.addEventListener("DOMContentLoaded", () => {
    // Get the element by id
    const element = document.querySelector('[data-resto-di="141"]');
    // Add the ondragstart event listener
    element.addEventListener("dragstart", (ev) => {
      ev.dataTransfert.setData("text/HTML", ev.target.outerHTML);
      ev.dataTrasnfer.dropEffect = "move";
    });
  });
});
