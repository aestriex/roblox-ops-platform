import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      handle: ".drag-handle",
      forceFallback: true,
      fallbackOnBody: true,
      group: { name: this.element.id, pull: false, put: false },
      onStart: this.onStart.bind(this),
      onEnd: this.onEnd.bind(this)
    })
  }

  disconnect() {
    // Stimulus treats any DOM reparenting (even a same-document move, which is how
    // Sortable reorders items) as a disconnect. If the element is still actually in
    // the document, this is a spurious disconnect from a move, not a real removal —
    // destroying Sortable here would corrupt its shared drag state mid-drag.
    if (!this.element.isConnected) this.sortable.destroy()
  }

  onStart() {
    // Sortable's fallback drag image is a deep clone of the dragged element, which
    // duplicates any nested data-controller markup (e.g. a section's questions list).
    // Stimulus would otherwise wire up a live controller for that throwaway clone,
    // and tearing it down when the clone is removed corrupts Sortable's shared
    // drag state, silently breaking onEnd for the real drag.
    Sortable.ghost?.querySelectorAll("[data-controller]").forEach((el) => el.removeAttribute("data-controller"))
  }

  onEnd() {
    const ids = Array.from(this.element.children).map(el => el.dataset.id)

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ ids: ids })
    })
  }
}
