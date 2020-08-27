class AddMessageToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :message, :text
  end
end
