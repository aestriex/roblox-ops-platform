import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "form", "input"]
  static values = {
    blurAction: { type: String, default: "cancel" },
    clearOnEdit: { type: Boolean, default: false }
  }

  connect() {
    this.handleFocusOut = this.handleFocusOut.bind(this)
    this.formTarget.addEventListener("focusout", this.handleFocusOut)
  }

  disconnect() {
    this.formTarget.removeEventListener("focusout", this.handleFocusOut)
  }

  edit() {
    // "!hidden" (Tailwind's important modifier), not "hidden" -- the display
    // target often also carries "flex"/"inline-flex", which ties with plain
    // "hidden" in specificity and can win the cascade, silently no-op'ing
    // classList.add("hidden").
    this.displayTarget.classList.add("!hidden")
    this.formTarget.classList.remove("!hidden")
    if (this.clearOnEditValue) this.inputTarget.value = ""
    this.inputTarget.focus()
    if (typeof this.inputTarget.select === "function") this.inputTarget.select()
  }

  cancel() {
    this.formTarget.classList.add("!hidden")
    this.displayTarget.classList.remove("!hidden")
  }

  // Closes the inline editor immediately (rather than waiting on the
  // network round trip) so it never looks like it "didn't close".
  // The server response still replaces the underlying content shortly after.
  save() {
    this.cancel()
    this.formTarget.requestSubmit()
  }

  submitOnEnter(event) {
    if (event.key === "Escape") {
      this.cancel()
      return
    }

    const isMultiline = event.target.tagName === "TEXTAREA"
    const shortcutSubmit = event.metaKey || event.ctrlKey

    if (event.key === "Enter" && (!isMultiline || shortcutSubmit)) {
      event.preventDefault()
      this.save()
    }
  }

  handleFocusOut(event) {
    if (this.formTarget.contains(event.relatedTarget)) return

    if (this.blurActionValue === "save") {
      this.save()
    } else {
      this.cancel()
    }
  }
}
