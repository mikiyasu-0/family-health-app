FactoryBot.define do
  factory :invitation do
    association :group
    association :invited_by, factory: :user
    expires_at { 7.days.from_now }
  end
end
