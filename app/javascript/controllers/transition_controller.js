import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["transitionable"]

  initialize() {
    this.isMenuShown = false;
  }

  async toggleProfileMenu() {
    if (this.isMenuShown) {
      await leave(this.transitionableTarget);

      this.transitionableTarget.classList.add("hidden");
    }
    else {
      this.transitionableTarget.classList.remove("hidden")

      await enter(this.transitionableTarget);
    }

    this.isMenuShown = !this.isMenuShown;
  }
}
