import UIDialog from "controllers/ui/dialog_controller";

export default class extends UIDialog {
  static targets = [...UIDialog.targets, "backButton", "backIcon", "title"]

  connect() {
    super.connect()
    this.stack = []
  }

  // loadFrame(url, title = "") {
  //   const frame = this.element.querySelector("#sheet_content_frame")

  //   if (this.dialogTarget.dataset.state === "open") {
  //     this.stack.push({ src: frame.src, title: this.titleTarget.textContent })
  //   } else {
  //     this.stack = []
  //   }

  //   this.titleTarget.textContent = title
  //   frame.src = url
  //   this.updateBackIcon()
  //   this.openBy(this.element)
  // }

  loadFrame(url, title = "") {
    const frame = this.element.querySelector("#sheet_content_frame")
    this.stack.push({ src: frame.src, title: this.titleTarget.textContent })
    this.titleTarget.textContent = title

    frame.innerHTML = `
      <div class="flex items-center justify-center p-12">
        <svg class="animate-spin h-5 w-5 text-muted-foreground" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
        </svg>
      </div>
    `

    frame.src = url
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
