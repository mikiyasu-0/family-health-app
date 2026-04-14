class CreateExerciseRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :exercise_records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :exercise_type, null: false
      t.text :memo

      t.timestamps
    end
  end
end
