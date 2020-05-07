class AddCommentsCountToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :comments_count, :integer
  end
end
