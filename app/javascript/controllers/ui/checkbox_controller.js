import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "checkmark", "input"]

  connect() {
    this.sync()
  }

  // Used by the visible button, which has no native association with the
  // real checkbox and must flip it explicitly.
  toggle() {
    this.inputTarget.checked = !this.inputTarget.checked
    this.sync()
  }

  // Used by the real checkbox's own change event, so any way it gets
  // toggled (native label click, keyboard, the button above) ends up
  // reflected visually exactly once.
  sync() {
    const checked = this.inputTarget.checked
    this.checkmarkTarget.classList.toggle("hidden", !checked)
    this.buttonTarget.dataset.state = checked ? "checked" : "unchecked"
  }
}
