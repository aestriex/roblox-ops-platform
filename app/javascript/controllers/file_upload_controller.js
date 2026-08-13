import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "label", "dropzone"]

  connect() {
    this.dropzoneTarget.addEventListener("dragover", this.dragOver.bind(this))
    this.dropzoneTarget.addEventListener("dragleave", this.dragLeave.bind(this))
    this.dropzoneTarget.addEventListener("drop", this.drop.bind(this))
  }

  open() {
    this.inputTarget.click()
  }

  dragOver(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("border-primary", "bg-primary/5")
  }

  dragLeave() {
    this.dropzoneTarget.classList.remove("border-primary", "bg-primary/5")
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("border-primary", "bg-primary/5")

    const files = event.dataTransfer.files
    if (files.length > 0) {
      this.inputTarget.files = files
      this.updateLabel()
    }
  }

  change() {
    this.updateLabel()
  }

  updateLabel() {
    if (this.inputTarget.files.length > 0) {
      this.labelTarget.textContent = this.inputTarget.files[0].name
    } else {
      this.labelTarget.textContent = "Click to upload or drag and drop"
    }
  }
}
