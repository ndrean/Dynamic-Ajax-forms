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

Then we change by hand the id of the inputs, then you 'dynamically' create a nested form with two instances of 'address".

You then can fill it and Rails accepts it. We just automatize this with JS and we have a simple dynamic nested form.
