class CreateGroupMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :group_memberships do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
