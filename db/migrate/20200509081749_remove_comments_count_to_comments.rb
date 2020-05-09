class RemoveCommentsCountToComments < ActiveRecord::Migration[6.0]
  def change
    remove_column :comments, :comments_count, :integer
  end
end
