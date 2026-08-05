class ContactMailer < ApplicationMailer
  def notify_admin(contact)
    @contact = contact

    mail(
      to: ENV.fetch("CONTACT_EMAIL"),
      reply_to: @contact.email,
      subject: "【ファミリーステップ】お問い合わせが届きました"
    )
  end
end
