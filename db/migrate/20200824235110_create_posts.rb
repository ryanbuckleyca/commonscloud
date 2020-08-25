class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :post_type
      t.references :category, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: { to_table: 'users' }
      t.string :title
      t.string :description
      t.string :location
      t.string :priority

      t.timestamps
    end
  end
end
