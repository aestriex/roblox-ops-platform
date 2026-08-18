import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { outlet: String, url: String, title: String }

  open(event) {
    event.preventDefault()
    const sheetElement = document.querySelector(this.outletValue)
    const sheetController = this.application.getControllerForElementAndIdentifier(sheetElement, "ui--sheet")
    sheetController.loadFrame(this.urlValue, this.titleValue)
  }
}
