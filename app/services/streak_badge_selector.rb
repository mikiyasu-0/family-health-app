class StreakBadgeSelector
  BADGES = [
    {
      threshold: 30,
      name: "1ヶ月達成バッジ",
      message: "1ヶ月連続達成！",
      icon: "🏆"
    },
    {
      threshold: 14,
      name: "2週間達成バッジ",
      message: "2週間連続達成！",
      icon: "🏅"
    },
    {
      threshold: 7,
      name: "1週間達成バッジ",
      message: "1週間連続達成！",
      icon: "🔥"
    },
    {
      threshold: 3,
      name: "3日達成バッジ",
      message: "3日連続達成！",
      icon: "🌟"
    }
  ].freeze

  def initialize(streak_count)
    @streak_count = streak_count.to_i
  end

  def call
    BADGES.find { |badge| streak_count >= badge[:threshold] }
  end

  private

  attr_reader :streak_count
end
