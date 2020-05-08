# README

Testing dynamic nested forms and AJAX Server Rendering with a simple one-to-many association with two models (Restaurant/Comments).

The two 'index' views are rendered as tables, the field cells are editable and saved on the fly.

The delete is also made AJAX.

Error handling and form validation to be finished.

TODO : fetch.

## Dynamic nested form

Take two models _Restaurant_ and _Comment_ with fields resp. _name_ and _comment_ where

```ruby
class Resto < ApplicationRecord
    has_many :comments, dependent: :destroy
    validates :name, uniqueness: true
    accepts_nested_attributes_for :comments
end

class Comment < ApplicationRecord
  belongs_to :resto
  validates :comment, length: {minimum: 2}
end
```

In the _restos_controller#new_ method, we add `@resto.comments.build`. In the view _#view/people/new_, after the formbuilder `form_with` for the parent `model: @resto`, we have the formbuilder `fields_for` for the association.

Open the browser's code inspector, and simply append a copy of the fields_for HTML part:

```
<fieldset class="form-group  fieldComment" data-id="0">
    <label for="resto_comments_attributes_0_Comment:">Comment:</label>
    <input required="required" type="text" name="resto[comments_attributes][0][comment]" ">
</fieldset>
```

Then we change by hand the _child_index_value_ of the input, then you 'dynamically' create a nested form with two instances of 'address".

You then can fill it and Rails accepts it. We just automatize this with JS and we have a simple dynamic nested form.
In particular, we inject the identification `<%= c.index %>` as a dataset of Javascript:

```
<%= f.fields_for :comments do |c| %>
    <fieldset class="form-group  fieldComment" data-id = "<%= c.index%>">
        <%= c.label "Comment:" %>
        <%= c.text_field :comment, required: true %>
    </fieldset>
<% end %>
```

## Setup

We can whether declare a function in the Javascript pack or use JS in a _js.erb_ file. The last stragey is much more compatible with Turbolinks whilst the first needs to disable Turbolinks on the page to work.

First stragegy:

```js
// # restos/new.js.erb

document
  .getElementById("form_Resto")
  .insertAdjacentHTML(
    "afterbegin",
    `<%= j render 'restos/form', resto: @resto %>`
  );

function dynComment() {
  const createCommentButton = document.getElementById("addComment");
  createCommentButton.addEventListener("click", (e) => {
    e.preventDefault();
    const arrayComments = [...document.querySelectorAll("fieldset")];
    const lastId = arrayComments[arrayComments.length - 1];
    const newId = parseInt(lastId.dataset.fieldsId, 10) + 1;

    document.querySelector("#new_resto").insertAdjacentHTML(
      "beforeend",
      `
      <fieldset data-fields-id="${newId}">
      <div class="form-group string optional resto_comments_comment data-id="${newId}">
      <label class="string optional" for="resto_comments_attributes_${newId}_comment">Comment</label>
      <input class="form-control string optional" type="text" name="resto[comments_attributes][${newId}][comment]" id="resto_comments_attributes_${newId}_comment">
      </div>
      </fieldset>
       `
    );
  });
}

document.getElementById("addComment").onclick = dynComment();
```

Second strategy: we need to:

- use formbuilder `form_with` with `model: @resto`
- use the formbuilder `fields_for`for the association `:comments`: it will render a block for each element in the association
- we use `@resto.comments.build` to prebuild the association in the controller
- We must await until *Turbolinks*is loaded to enable the Javascript
- We must disable _Turbolinks_ on the link to this page with: `&ltlink_to 'this page", 'nests/new', data: {turbolinks: false}%>`

### Javacsript setup

```js
# views/layout/application
 <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload', defer: true %>

# javacsript/packs/applications.js
import { createComment } from "../components/createComment.js";
// for Turbolinks to work with Javascript
document.addEventListener("turbolinks:load", () => {
  const createCommentButton = document.getElementById("newComment");
    if (createCommentButton) {
      createComment();
    }
});
```

When the button _ create comment_ is clicked, we want to inject by Javascript a new input block used for _comment_ We need a unique id for the input field. Since we have access to the formbuilder index, we save this id in a dataset, namely add it to the fieldset that englobes our label/input block. By JS, we can attribute a unique id to the new input by reading the last block.

````

## Editable on the fly

We can edit directly the name of the restaurant and save. There is a hidden form under the button _submit_. We use the form helper `form_with` and provide the object `model: resto` (no '@' since it is in an iteration loop);
then `form_with` determines that `resto` is **not a new instance** of `Resto`, so **automatically<** use the _update_ path. When Rails renders the HTML, the form is initially populated with the object values. Since we want to change them, there is a listener on the editable cells of the names of the restaurants. If they is a change in one of the cells, the event will be captured, and copied into the input of the hidden form.

The JS helper that copies directly from the cell to the form input every change in the cell.

```js
const copyActive = (tag) => {
  document.querySelectorAll("td").forEach((td) => {
    td.addEventListener("input", (e) => {
      const id = e.target.dataset.editable;
      document.querySelector(tag + id).value = e.target.innerText;
    });
  });
};
```

Then when we _submit_ the form, this persists to the database with _PATCH / UPDATE_ in the background so the process is dynamic.

### Delete and Ajax

The Delete method is Ajax rendered. The link calls the _restos#destroy_ method. It reads the query string with the _params hash_, then querries the database with the found _ID_ and delete it from the database.

We declared `dependent: :destroy` in the model; this is similar to `@resto.comments.destroy_all` so all associated objects will be deleted together with the parent.

Then the link has the attribute `remote: true`, so the method will respond to with _destroy.js.erb_ to render dynamically
the view in the browser. To update the view, namely delete a row, we need to select it with Javascript so we need to pass the ID information
from Rails to Javascript to be able to remove the correct row. We use datasets for this. When Rails renders the HTML, Rails will write the IDs given by the database in a dataset for every object, with the HTML.ERB code:

```
<tr data-resto-id = '&lt%=resto.id%>'>
```

(we used a `<table>` to present the data above).

Since we use the file format _js.erb_, this file will be firstly parsed by Rails and then Javascript. The code of this file is:

```js
document.querySelector('[data-resto-id = &lt%= @resto.id %>"]').remove();
```

In the first parse, Rails _restos#destroy_ knows the instance `@resto` and will put the 'real' value for `&lt%= @resto.id %>`, say "13" for example. Then Javascript reads the string `data-resto-id = "13"`, finds the correct `&lttr>` in the DOM, and acts with `.remove()`. Et voilà.

## Error rendering - form validation

Browser validation `required: true` with the setup `config.browser_validations = true` used with _simple_form_for_ in _#config/initializers/simple_form.rb_

```ruby
#shared/_erros.html.erb
<% if myvar.errors.any? %>
    <div>
      <h2><%= pluralize(myvar.errors.count, "error") %> prohibited this item from being saved:</h2>

      <ul>
        <% myvar.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
```

```ruby
<%= simple_form_for @resto, url: 'restos#create',  remote: true do |f| %>
  <%= render 'shared/errors', myvar: f.object %>
  ...
```

```js
if (<%= @resto.errors.any? %>) {
    console.log('Errors')
    document.querySelector("#new_resto").remove()
    document.getElementById('form_Resto').insertAdjacentHTML('beforeend',`<%= j render 'restos/form', resto: @resto %>`)

} else {
    console.log('SJR')
    document.querySelector('tbody').insertAdjacentHTML('beforeend', `<%= j render 'restos/trow', resto: @resto %>`)
    // document.querySelector("#new_resto").remove()
    document.querySelector('#form_Resto').innerHTML = ""
```

### Fontawesome setup

```ruby
# gemfile
gem 'font-awesome-sass', '~> 5.12'
#application.scss (respect the order)
@import "font-awesome-sprockets";
@import "font-awesome";
```

### Bootstrap setup

```bash
yarn add bootstrap
```

```ruby
#application.scss
@import "bootstrap/scss/bootstrap";
```

### Faker

```ruby
#gemfile
group :development do
  gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'
end
```
````
