class AddConnectionToMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :connection, null: false, foreign_key: true
  end
end
