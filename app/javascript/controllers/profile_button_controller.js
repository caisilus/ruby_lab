import { Controller } from "@hotwired/stimulus"
import {enter, leave, toggle} from "el-transition"

export default class extends Controller {
  static targets = ["profileMenu"]

  initialize() {
    this.isMenuShown = false;
  }

  async toggleProfileMenu() {
    console.log("Toggle profile menu");
    console.log(this.isMenuShown);

    if (this.isMenuShown) {
      await leave(this.profileMenuTarget);

      this.profileMenuTarget.classList.add("hidden");
    }
    else {
      this.profileMenuTarget.classList.remove("hidden")

      await enter(this.profileMenuTarget);
    }
    this.isMenuShown = !this.isMenuShown;
  }
}
