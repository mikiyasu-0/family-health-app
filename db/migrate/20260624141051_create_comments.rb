class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise_record, null: false, foreign_key: true
      t.string :body, null: false, limit: 100

      t.timestamps
    end
  end
end
