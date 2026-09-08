import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dot"];

  connect() {
    this.ready = false;
    requestAnimationFrame(() => {
      this.ready = true;
    });
  }

  dotTargetConnected() {
    if (!this.ready) return;

    this.element.classList.add("notification-bell-flash");
    setTimeout(() => this.element.classList.remove("notification-bell-flash"), 700);
  }
}
