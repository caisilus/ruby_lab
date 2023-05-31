import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-hidden"
export default class extends Controller {
  static targets = ["toggleable"]

  toggleHidden() {
    this.toggleableTargets.forEach(item => item.classList.toggle("hidden"));
  }
}
