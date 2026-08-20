import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["item"];
  static classes = ["hidden"];
  static values = { key: String };

  connect() {
    this.class = this.hasHiddenClass ? this.hiddenClass : "hidden";

    if (this.hasKeyValue && localStorage.getItem(this.storageKey) === "collapsed") {
      this.hide();
    }
  }

  toggle() {
    this.itemTargets.forEach((item) => {
      item.classList.toggle(this.class);
    });

    if (this.hasKeyValue) {
      const collapsed = this.itemTargets[0]?.classList.contains(this.class);
      localStorage.setItem(this.storageKey, collapsed ? "collapsed" : "expanded");
    }
  }

  get storageKey() {
    return `sidebar-collapsed:${this.keyValue}`;
  }

  show() {
    this.itemTargets.forEach((item) => {
      item.classList.remove(this.class);
    });
  }

  hide() {
    this.itemTargets.forEach((item) => {
      item.classList.add(this.class);
    });
  }
}
