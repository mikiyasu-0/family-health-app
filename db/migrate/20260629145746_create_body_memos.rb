class CreateBodyMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :body_memos do |t|
      t.references :user, null: false, foreign_key: true
      t.date :memo_date, null: false
      t.text :content, null: false
      t.boolean :fallback, null: false, default: false

      t.timestamps
    end

    add_index :body_memos, [:user_id, :memo_date], unique: true
  end
end
