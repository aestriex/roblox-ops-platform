import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["table", "kanban", "tableIcon", "kanbanIcon"]

  connect() {
    if (localStorage.workItemsView === "kanban") {
      this.showKanban()
    }
  }

  showTable() {
    this.tableTarget.classList.remove("hidden")
    this.kanbanTarget.classList.add("hidden")
    this.tableIconTarget.classList.add("bg-accent")
    this.kanbanIconTarget.classList.remove("bg-accent")
    localStorage.workItemsView = "table"
  }

  showKanban() {
    this.kanbanTarget.classList.remove("hidden")
    this.tableTarget.classList.add("hidden")
    this.kanbanIconTarget.classList.add("bg-accent")
    this.tableIconTarget.classList.remove("bg-accent")
    localStorage.workItemsView = "kanban"
  }
}
