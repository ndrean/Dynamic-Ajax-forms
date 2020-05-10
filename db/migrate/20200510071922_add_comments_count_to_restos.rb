class AddCommentsCountToRestos < ActiveRecord::Migration[6.0]
  def change
    add_column :restos, :comments_count, :integer
  end
end
