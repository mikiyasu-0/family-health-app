class GuestSampleDataCreator
  def initialize(guest_user)
    @guest_user = guest_user
  end

  def call
    group = create_group
    sample_users = create_sample_users

    add_users_to_group(group, sample_users)
    create_exercise_records(sample_users)
  end

  private

  attr_reader :guest_user

  def create_group
    Group.create!(name: "ゲスト家族")
  end

  def create_sample_users
    [
      create_sample_user("お父さん"),
      create_sample_user("お母さん")
    ]
  end

  def create_sample_user(name)
    User.create!(
      name: name,
      email: "guest_sample_#{SecureRandom.uuid}@example.com",
      password: SecureRandom.urlsafe_base64,
      guest: true
    )
  end

  def add_users_to_group(group, sample_users)
    GroupMembership.create!(
      user: guest_user,
      group: group,
      role: :admin
    )

    sample_users.each do |sample_user|
      GroupMembership.create!(
        user: sample_user,
        group: group,
        role: :member
      )
    end
  end

  def create_exercise_records(sample_users)
    father, mother = sample_users

    ExerciseRecord.create!(
      user: father,
      exercise_type: "walk",
      memo: "今日は近所をゆっくり散歩しました。",
      created_at: Time.current
    )

    ExerciseRecord.create!(
      user: mother,
      exercise_type: "heel_raise",
      memo: "テレビを見ながらかかと上げをしました。",
      created_at: Time.current
    )

    ExerciseRecord.create!(
      user: father,
      exercise_type: "chair_squat",
      memo: "昨日は椅子スクワットを無理なく行いました。",
      created_at: 1.day.ago
    )
  end
end
