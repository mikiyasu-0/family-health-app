import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  static values = {
    inviteUrl: String,
    shareTitle: String,
    shareText: String
  }

  async copy() {
    const url = this.inviteUrlValue

    try {
      await navigator.clipboard.writeText(url)

      this.messageTarget.textContent = "招待リンクをコピーしました。"
    } catch (error) {
      this.messageTarget.textContent = "コピーに失敗しました。リンクを手動でコピーしてください。"
    }
  }

  async share() {
    if (!navigator.share) {
      this.messageTarget.textContent = "この端末では共有機能が使えません。コピーして送ってください。"
      return
    }

    try {
      await navigator.share({
        title: this.shareTitleValue,
        text: this.shareTextValue,
        url: this.inviteUrlValue
      })

      this.messageTarget.textContent = "共有画面を開きました。"

    } catch (error) {
      this.messageTarget.textContent = "共有をキャンセルしました。"
    }
  }
}
