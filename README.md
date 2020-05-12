# README

- [Dynamic nested form](#dynamic-nested-form)
- AJAX Server Rendering (form submission, delete) with a simple one-to-many association with two models (Restaurant/Comments).
- [Editable on the fly](#editable-on-the-fly)
- [Delete Ajax](#delete-ajax)

- [Drag & Drop](#drag-drop) with `fetch()` 'POST' and `csrfToken()`
- [Error rendering & form validation](##error-rendering) for browser & backend
- [Kaminari](#kaminari-ajax) setup with Ajax rendering pagination

- [Setup](#setup)
  - [Database model](#database-model)
  - [Counter cache](#counter-cache) quick setup, child model and parent model
  - [Fontawsome](#fontawesome) setup with a _gem_ and `@import`
  - [Bootstrap](#bootstrap) setup with _yarn_ and `@import`

## Dynamic nested form

Take a three model _one-to-many_ with _Type_, _Restaurant_ and _Comment_ with fields resp. _name_, _name_ and _comment_ where
![Database](demo/db.png)

```ruby
class Genre < ApplicationRecord
  has_many :restos
  validates :name, presence: true, uniqueness: true
end

class Resto < ApplicationRecord
    has_many :comments, dependent: :destroy
    belongs_to :genre, optional: true
    validates :name, uniqueness: true, presence: true
    accepts_nested_attributes_for :comments
end

class Comment < ApplicationRecord
  belongs_to :resto, counter_cache: true
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

- We used the formbuilder `form_with` with `model: @resto`
- we use the formbuilder `fields_for`for the association `:comments`: it will render a block for each element in the association
- we use `@resto.comments.build` to prebuild the association in the controller

```
<%= f.fields_for :comments do |c| %>
    <fieldset class="form-group  fieldComment" data-id = "<%= c.index%>">
        <%= c.label "Comment:" %>
        <%= c.text_field :comment, required: true %>
    </fieldset>
<% end %>
```

![Demo adding dynamic form](demo/dynamic-nested-form.gif)

###Setup

We can whether declare a function in the Javascript pack or use JS in a _js.erb_ file. The last stragey is much more compatible with Turbolinks whilst the first needs to disable Turbolinks on the page to work.

First stragegy: we want a button to display a new form, this will be our _restos#new_ method. In the form generated by JS, besides the input fields (parent and associated model), we have a _create button_ and a _submit_ button. We need to build the Javascript function that adds associated fields on the fly in a _js.erb_ file. On clic of the _add_ button, we build the associated fields.

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

Second strategy:

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
  [... all other methods called here ....]
});
```

When the button _ create comment_ is clicked, we want to inject by Javascript a new input block used for _comment_ We need a unique id for the input field. Since we have access to the formbuilder index, we save this id in a dataset, namely add it to the fieldset that englobes our label/input block. By JS, we can attribute a unique id to the new input by reading the last block.

## Editable on the fly

[Back to Contents](#readme)

We can edit directly the name of the restaurant and save. There is a hidden form under the button _submit_. We use the form helper `form_with` and provide the object `model: resto` (no '@' since it is in an iteration loop);
then `form_with` determines that `resto` is **not a new instance** of `Resto`, so **automatically<** use the _update_ path. When Rails renders the HTML, the form is initially populated with the object values.

We attached a listener to every editable cells (the names of the restaurants), and every change is captured with the event `input`. Every event triggers a copy of the innerText into the input of the hidden form. The form is then submitted to the database with PATCH / UPDATE, so this happens in the background.
Since we want to change them, there is a listener on the editable cells of the names of the restaurants. If they is a change in one of the cells, the event will be captured, and copied into the input of the hidden form.

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

## Add on the fly

View: comments. We can create a comment and select the parent model (restaurant) from a _select_ list. We can also a new restaurant which will populate the _select_ list and appear on the top. All Ajax.

## Delete Ajax

[Back to Contents](#readme)

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

## Drag Drop

[Back to Contents](#readme)

- we need to add the _draggable_ attribute to the node we want to make draggable
- we add a listener on the _dragstart_ event to capture the start of the drag and capture data in the _DataTansfer_ object. The `dataTransfer.setData()` method sets the data type and the value of the dragged data. We can only pass a string in it so we stringify the object we pass.

```js
document.addEventListener("dragstart", (e) => {
    // we define the data that wil lbe transfered with the dragged node
    const draggedObj = {
      idSpan: e.target.id,
      resto_id: e.target.dataset.restoId,
    };
    e.dataTransfer.setData("text", JSON.stringify(draggedObj));
```

By default, data/elements cannot be dropped in other elements. To allow a drop on an element, it needs:

- to listen to the _dragover_ event to prevent the default handling of the element,

```js
document.addEventListener("dragover", (e) => {
  e.preventDefault();
});
```

- listen to the _drop_ event: here we accept to drop on an element that has the class "drop-zone". We can then use the data contained in the _DataTransfer_ object with the `dataTransfer.setData()` method.

Here, we use the data to `fetch()` with _POST_ to reassign the dragged element with a local property and persist to the database.

```js
document.addEventListener("drop", async (e) => {
    e.preventDefault();
    // permits drop only in elt with class 'drop-zone'
    if (e.target.classList.contains("drop-zone")) {
      const transferedData = JSON.parse(e.dataTransfer.getData("text"));

      const data = {
        resto: {
          genre_id: e.target.parentElement.dataset.genreId,
          id: transferedData.resto_id,
        },
      };

      await postGenreToResto(data).then((data) => {
        if (data) {
          // status: ok
          e.target.appendChild(document.getElementById(transferedData.idSpan));
        }
      });
    }
  });
}

```

## Error rendering

[Back to Contents](#readme)

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

To render errors when the form is AJAX submitted, we can do:

```js
if (<%= @myobject.errors.any? %>) {
    const myDivAboveTheForm = document.querySelector("#myDivAboveTheForm")
    myDivAboveTheForm.innerHTML = ""
    myDivAboveTheForm.insertAdjacentHTML('beforeend',`<%= j render 'restos/form' %>`)

} else {
    ....do something
}
```

## Kaminari AJAX

[Back to Contents](#readme)

Installation: put `gem kaminari` in _gemfile_, `bundle`, and run `rails g kaminari:config`: this generates the default configuration file into _config/initializers_ directory. We set here:

```ruby
#/config/initializers/kaminari_config.rb
Kaminari.configure do |config|
  config.default_per_page = 5
end
```

We tweaked the pagination helper with Bootstrap4 template them, running `rails g kaminari:view bootstrap4`.

```ruby
class CommentsController < ApplicationController

  # GET /comments
  def index
    @comments = Comment.includes([:resto]).page(params[:page])
    respond_to do |format|
      format.js
      format.html
    end
  end
```

In the _index.html.erb_ views of _Comments_, we add the pagination link and extract a partial of the data that will be paginated (namely the `<tbody>` part)

```
# views/comments/index.html.erb
<div id="paginator">
    <%= paginate(@comments, remote: true)  %>
</div>

<table>
  <thead>
  ...
  <tbody id="tb-comments">
    <%= render 'comments/table_comments', comments: @comments %>
  </tbody>
  </thead>
</table>
```

We extract in a partial the body of the table that will be paginated
where the partial that iterates oever `@comments = Comment.all`:

```
# /views/comments/_table_comments.html.erb
<% comments.each do |comment| %>
    <tr data-comment-id= "<%= comment.id %>" >
    <td contenteditable="true" data-editable="<%= comment.id %>"><%= comment.comment %> </td>
    <td><%= comment.resto.name %></td>
    ...
```

And we create a file _index.js.erb_ that contains:

```js
document.querySelector("#tb-comments").innerHTML = "";
document.querySelector(
  "#tb-comments"
).innerHTML = `<%= j render 'comments/table_comments', comments: @comments %>`;
document.querySelector(
  "#paginator"
).innerHTML = `<%= j paginate(@comments, remote: true)%>`;
```

Et voilà.

## Setup

[Back to Contents](#readme)

### Database model

![Database](demo/db.png)

```
> rails g model genre name
> rails g model resto name comments_count:integer genre:references
> rails g model comment comment resto:references
> rails db:create db:migrate
```

```sql
#postgresql
CREATE TABLE "Genres" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar,
  "created_at" timestamp
);
CREATE TABLE "Restos" (
  "id" int PRIMARY KEY,
  "name" varchar,
  "comments_count" integer,
  "genre_id" int,
  "created_at" timestamp
);
CREATE TABLE "Comments" (
  "code" int PRIMARY KEY,
  "comment" varchar,
  "resto_id" int
);
ALTER TABLE "Restos" ADD FOREIGN KEY ("genre_id") REFERENCES "Genres" ("id");
ALTER TABLE "Comments" ADD FOREIGN KEY ("resto_id") REFERENCES "Restos" ("id");
```

### Counter cache

In the view _#views/restos/index.html.erb_, we have an iteration with a counting output `<td> <%= resto.comments.size %></td>`. If we use `count`, we fire an SQL query. We can use _counter_cache_ to persist the count in the database and Rails will update the counter for us whenever a comment is added or removed.

> Add `counter_cache` in the _child_ model (`Comment`here).

```ruby
class Comment < ApplicationRecord
  belongs_to :resto, counter_cache: true
  # requires a field comments_count to the Resto model
  validates :comment, length: {minimum: 2}
end
```

> Add a field `comments_count` to the _parent_ model (`Resto`model here).

```
rails g migration AddCommentsCountToRestos comments_count:integer
rails db:migrate
```

> Note: to count the number of comments by restaurant with SQL/Ruby, we do:

```sql
JOINS( 'restos' )
.SELECT ("restos.*, 'COUNT("comments.id") AS comments_count')
.GROUP('restos.id')
```

<https://blog.appsignal.com/2018/06/19/activerecords-counter-cache.html>

### Fontawesome

```ruby
# gemfile
gem 'font-awesome-sass', '~> 5.12'
#application.scss (respect the order)
@import "font-awesome-sprockets";
@import "font-awesome";
```

### Bootstrap

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

[Back to Contents](#readme)
