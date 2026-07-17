namespace :guest_users do
  desc "Delete old guest users and related data"
  task cleanup: :environment do
    retention_days = ENV.fetch("GUEST_USER_RETENTION_DAYS", 7).to_i

    result = GuestUserCleanupService.new(retention_days: retention_days).call

    puts "Guest user cleanup completed."
    puts "Deleted users: #{result[:deleted_users]}"
    puts "Deleted groups: #{result[:deleted_groups]}"
    puts "Cutoff time: #{result[:cutoff_time]}"
  end
end
