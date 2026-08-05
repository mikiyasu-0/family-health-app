class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      begin
        ContactMailer.notify_admin(@contact).deliver_now

        redirect_to new_contact_path,
                    notice: "お問い合わせを送信しました。"
      rescue StandardError => error
        Rails.logger.error(
          "お問い合わせメールの送信に失敗しました: #{error.class} #{error.message}"
        )

        @contact.errors.add(
          :base,
          "お問い合わせを送信できませんでした。時間をおいて再度お試しください。"
        )

        render :new, status: :unprocessable_entity
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
