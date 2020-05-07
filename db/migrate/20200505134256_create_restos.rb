class CreateRestos < ActiveRecord::Migration[6.0]
  def change
    create_table :restos do |t|
      t.string :name

      t.timestamps
    end
  end
end
