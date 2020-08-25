class CreateConnections < ActiveRecord::Migration[6.0]
  def change
    create_table :connections do |t|
      t.references :responder, null: false, foreign_key: { to_table: 'users' }
      t.references :post, null: false, foreign_key: true
      t.string :status
      t.text :message

      t.timestamps
    end
  end
end
