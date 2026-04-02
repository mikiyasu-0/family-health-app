class AddUniqueIndexToGroupMemberships < ActiveRecord::Migration[7.2]
  def change
    add_index :group_memberships, [ :user_id, :group_id ], unique: true
  end
end
