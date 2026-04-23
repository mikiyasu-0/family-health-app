import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "panel"]

  open() {
    this.overlayTarget.classList.remove("hidden")
    this.panelTarget.classList.remove("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
    this.panelTarget.classList.add("hidden")
  }
}
