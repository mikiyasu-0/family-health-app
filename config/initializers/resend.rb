# config/initializers/resend.rb
require "resend"

if Rails.env.production?
  Resend.api_key = ENV.fetch("RESEND_API_KEY")
else
  Resend.api_key = ENV["RESEND_API_KEY"]
end
