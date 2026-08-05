class ApplicationMailer < ActionMailer::Base
  default from: Rails.env.test? ? "from@example.com" : ENV.fetch("MAIL_FROM")
  layout "mailer"
end
