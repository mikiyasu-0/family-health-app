class CreateReactions < ActiveRecord::Migration[7.2]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise_record, null: false, foreign_key: true
      t.string :reaction_type, null: false

      t.timestamps
    end

    add_index :reactions, [ :user_id, :exercise_record_id, :reaction_type ], unique: true
  end
end
