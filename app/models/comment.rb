class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :exercise_record

  validates :body, presence: true, length: { maximum: 100 }
end
