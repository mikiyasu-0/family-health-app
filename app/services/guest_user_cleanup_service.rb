class GuestUserCleanupService
  DEFAULT_RETENTION_DAYS = 7

  def initialize(retention_days: DEFAULT_RETENTION_DAYS)
    @cutoff_time = retention_days.days.ago
  end

  def call
    groups = old_guest_only_groups
    users = old_guest_users

    deleted_group_count = groups.count
    deleted_user_count = users.count

    ActiveRecord::Base.transaction do
      groups.each(&:destroy!)

      users.find_each do |user|
        user.destroy!
      end
    end

    {
      deleted_users: deleted_user_count,
      deleted_groups: deleted_group_count,
      cutoff_time: cutoff_time
    }
  end

  private

  attr_reader :cutoff_time

  def old_guest_users
    User.where(guest: true).where("created_at < ?", cutoff_time)
  end

  def old_guest_only_groups
    Group
      .includes(:users)
      .where("groups.created_at < ?", cutoff_time)
      .select do |group|
        group.users.any? &&
          group.users.all? { |user| user.guest? && user.created_at < cutoff_time }
      end
  end
end
