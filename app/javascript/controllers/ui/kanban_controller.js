import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static targets = ["column", "count"]

  connect() {
    this.columnTargets.forEach(column => {
      Sortable.create(column, {
        group: "kanban",
        animation: 150,
        forceFallback: true,
        fallbackTolerance: 3,
        emptyInsertThreshold: 20,
        onEnd: this.onEnd.bind(this)
      })
    })
  }

  onEnd(event) {
    if (event.from === event.to) return

    this.updateCounts()

    const url = event.item.dataset.url
    const newStatus = event.to.dataset.status

    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: `status=${newStatus}`
    }).then(response => {
      if (!response.ok) {
        event.from.insertBefore(event.item, event.from.children[event.oldIndex])
        this.updateCounts()
      }
    })
  }

  updateCounts() {
    this.countTargets.forEach(count => {
      const column = this.columnTargets.find(column => column.dataset.status === count.dataset.status)
      count.textContent = column.children.length
    })
  }
}
