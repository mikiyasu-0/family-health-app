class BodyMemo < ApplicationRecord
  belongs_to :user

  validates :memo_date, presence: true, uniqueness: { scope: :user_id }
  validates :content, presence: true
end
