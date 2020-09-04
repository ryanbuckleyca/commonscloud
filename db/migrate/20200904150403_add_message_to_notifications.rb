class AddMessageToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :message, null: false, foreign_key: true
  end
end
