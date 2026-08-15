import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "label"]

  select(event) {
    const item = event.currentTarget
    const value = item.dataset.value
    const label = item.textContent.trim()

    this.inputTarget.value = value
    this.labelTarget.textContent = label

    const popoverContent = this.element.querySelector('[data-ui--popover-target="content"]')
    popoverContent.classList.add("hidden")
    popoverContent.dataset.state = "closed"
  }
}
