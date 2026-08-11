import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "copyIcon", "checkIcon"]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value)

    this.copyIconTarget.classList.add("hidden")
    this.checkIconTarget.classList.remove("hidden")

    setTimeout(() => {
      this.copyIconTarget.classList.remove("hidden")
      this.checkIconTarget.classList.add("hidden")
    }, 2000)
  }
}
