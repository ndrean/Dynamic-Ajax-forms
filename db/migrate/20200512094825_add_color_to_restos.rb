class AddColorToRestos < ActiveRecord::Migration[6.0]
  def change
    add_column :restos, :color, :string
  end
end
