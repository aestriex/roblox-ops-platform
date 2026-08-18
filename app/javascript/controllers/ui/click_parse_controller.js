import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 250 } }
  static targets = ["display", "editForm"]

  connect() {
    if (this.hasEditFormTarget) {
      this.editFormTarget.addEventListener("keydown", this.handleKeydown.bind(this))
      this.editFormTarget.addEventListener("focusout", this.handleFocusOut.bind(this))
    }
  }

  handleClick(event) {
    this.timeout = setTimeout(() => {
      this.dispatch("singleClick")
    }, this.delayValue)
  }

  handleDblClick(event) {
    clearTimeout(this.timeout)
    this.displayTarget.classList.add("hidden")
    this.editFormTarget.classList.remove("hidden")

    const input = this.editFormTarget.querySelector("input, textarea, select")
    if (input) input.focus()
  }

  handleKeydown(event) {
    if (event.key === "Enter" && event.target.tagName !== "TEXTAREA") {
      event.preventDefault()
      this.editFormTarget.querySelector("form").requestSubmit()
    } else if (event.key === "Escape") {
      this.cancelEdit()
    }
  }

  handleFocusOut(event) {
    if (this.editFormTarget.contains(event.relatedTarget)) return

    this.editFormTarget.querySelector("form").requestSubmit()
  }

  cancelEdit() {
    this.editFormTarget.classList.add("hidden")
    this.displayTarget.classList.remove("hidden")
  }
}
