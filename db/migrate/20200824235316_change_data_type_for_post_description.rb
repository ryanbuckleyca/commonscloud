class ChangeDataTypeForPostDescription < ActiveRecord::Migration[6.0]
  def change
    change_table :posts do |t|
      t.change :description, :text
    end
  end
end
