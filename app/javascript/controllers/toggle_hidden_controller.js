import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-hidden"
export default class extends Controller {
  static targets = ["itemToToggle"]

  toggleHidden() {
    console.log("toggle to hidden!");
    this.itemToToggleTargets.forEach(item => item.classList.toggle("hidden"));
  }
}
