import UIDialog from "controllers/ui/dialog_controller";

export default class extends UIDialog {
  static targets = [...UIDialog.targets, "backButton", "backIcon", "title"]

  connect() {
    super.connect()
    this.stack = []
  }

  loadFrame(url, title = "") {
    const frame = this.element.querySelector("#sheet_content_frame")

    if (this.dialogTarget.dataset.state === "open") {
      this.stack.push({ src: frame.src, title: this.titleTarget.textContent })
    } else {
      this.stack = []
    }

    this.titleTarget.textContent = title
    frame.src = url
    this.updateBackIcon()
    this.openBy(this.element)
  }

  backOrClose(event) {
    if (this.stack.length === 0) {
      this.close(event)
    } else {
      const previous = this.stack.pop()
      const frame = this.element.querySelector("#sheet_content_frame")
      frame.src = previous.src
      this.titleTarget.textContent = previous.title
      this.updateBackIcon()
    }
  }

  updateBackIcon() {
    this.backIconTarget.innerHTML = this.stack.length > 0
      ? '<path d="m15 18-6-6 6-6"/>'
      : '<path d="M18 6 6 18"/><path d="m6 6 12 12"/>'
  }
}
