import { Controller } from "@hotwired/stimulus";

export default class UISearch extends Controller {
  static targets = ["source", "item"];
  static values = {
    pattern: String,
  };

  connect() {}

  search(event) {
    let lowerCaseSearchTerm = this.sourceTarget.value.toLowerCase();
    const regex = new RegExp(this.patternValue.replace("{input}", lowerCaseSearchTerm));
    if (this.hasItemTarget) {
      this.itemTargets.forEach((el, i) => {
        let searchableKey = el.innerText.toLowerCase();
        // Check for consecutive characters match using regex
        el.classList.toggle("hidden", !regex.test(searchableKey.trim()));
      });
    }
  }
}
