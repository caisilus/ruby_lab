import { Controller } from "@hotwired/stimulus"
import { enter, leave } from "el-transition"

export default class extends Controller {
  static targets = ["transitionable"]

  initialize() {
    this.entered = false;
  }

  async toggleTransition() {
    if (this.entered) {
      await this.transitionAll(leave);
    }
    else {
      await this.transitionAll(enter);
    }

    this.entered = !this.entered;
  }

  async transitionAll(transition) {
    this.element.dispatchEvent(new CustomEvent(`transition-${transition.name}-start`));

    await Promise.all(this.transitionableTargets.map(transitionable => transition(transitionable)));

    this.element.dispatchEvent(new CustomEvent(`transition-${transition.name}-end`));
  }
}
