class AddGuestToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :guest, :boolean, null: false, default: false
    add_index :users, :guest
  end
end
