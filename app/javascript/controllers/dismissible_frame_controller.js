import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { defaultUrl: String }

  connect() {
    this.boundClick = this.checkClick.bind(this)
    setTimeout(() => {
      document.addEventListener("click", this.boundClick)
    }, 0)
  }

  disconnect() {
    document.removeEventListener("click", this.boundClick)
  }

  checkClick(event) {
    if (this.element.src && !this.element.contains(event.target)) {
      this.element.src = this.defaultUrlValue
    }
  }
}
