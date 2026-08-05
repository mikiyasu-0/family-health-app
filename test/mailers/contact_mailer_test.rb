require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "notify_admin" do
    contact = Contact.new(
      name: "テストユーザー",
      email: "test@example.com",
      message: "お問い合わせメールのテスト内容です。"
    )

    mail = ContactMailer.notify_admin(contact)

    assert_equal(
      "【ファミリーステップ】お問い合わせが届きました",
      mail.subject
    )
    assert_equal [ ENV.fetch("CONTACT_EMAIL") ], mail.to
    assert_equal [ "test@example.com" ], mail.reply_to

    text_body = mail.text_part.body.decoded

    assert_match "テストユーザー", text_body
    assert_match "お問い合わせメールのテスト内容です。", text_body
  end
end
