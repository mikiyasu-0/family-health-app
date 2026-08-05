class Contact
  include ActiveModel::Model

  attr_accessor :name, :email, :message

  validates :name,
            presence: true,
            length: { maximum: 50 }
  
  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :message,
            presence: true,
            length: { minimum:10, maximum: 1_000 }
end
