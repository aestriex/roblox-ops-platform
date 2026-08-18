import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fieldList", "valueList"]

  showFields() {
    this.valueListTargets.forEach(el => el.classList.add("hidden"))
    this.fieldListTarget.classList.remove("hidden")
  }

  showValues(event) {
    const field = event.currentTarget.dataset.field
    this.fieldListTarget.classList.add("hidden")
    this.valueListTargets.forEach(el => {
      el.classList.toggle("hidden", el.dataset.field !== field)
    })
  }
}
