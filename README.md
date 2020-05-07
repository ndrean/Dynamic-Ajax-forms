# README

Testing dynamic nested forms and AJAX Server Rendering with a simple one-to-many association with two models (Restaurant/Comments).

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

````
<%= f.fields_for :comments do |c| %>
    <fieldset class="form-group  fieldComment" data-id = "<%= c.index%>">
        <%= c.label "Comment:" %>
        <%= c.text_field :comment, required: true %>
    </fieldset>
<% end %>
```

## Setup

To add several comments, we need to:

- use formbuilder `<code>`form_with`</code>` with `model: @resto`
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
When the button * create comment* is clicked, we want to inject by Javascript a new input block used for *comment* We need a unique id for the input field. Since we have access to the formbuilder index, we save this id in a dataset, namely add it to the fieldset that englobes our label/input block. By JS, we can attribute a unique id to the new input by reading the last block.
````
