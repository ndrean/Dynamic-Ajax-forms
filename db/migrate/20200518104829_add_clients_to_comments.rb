class AddClientsToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :client, foreign_key: true
  end
end
