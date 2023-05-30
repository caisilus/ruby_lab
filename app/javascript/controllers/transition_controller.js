import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["transitionable"]

  initialize() {
    this.entered = false;
  }

  async toggleTransition() {
    if (this.entered) {
      await this.transitionLeave();
    }
    else {
      await this.transitionEnter();
    }

    this.entered = !this.entered;
  }

  async transitionLeave() {
    await Promise.all(this.transitionableTargets.map(transitionable => leave(transitionable)));

    this.transitionableTargets.forEach(transitionable => transitionable.classList.add("hidden"));

    let event = new CustomEvent("transition-left");
    document.dispatchEvent(event);
  }

  async transitionEnter() {
    let event = new CustomEvent("transition-enter");
    document.dispatchEvent(event);

    this.transitionableTargets.forEach(transitionable => transitionable.classList.remove("hidden"));

    await Promise.all(this.transitionableTargets.map(transitionable => enter(transitionable)));
  }
}
