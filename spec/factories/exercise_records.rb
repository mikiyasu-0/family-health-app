FactoryBot.define do
  factory :exercise_record do
    association :user
    exercise_type { "walk" }
    memo { "散歩しました" }
  end
end
