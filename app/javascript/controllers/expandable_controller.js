import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["collapsedIcon", "expandedIcon", "expandableList"]

    toggle() {
        this.expandedIconTarget.classList.toggle("hidden")
        this.collapsedIconTarget.classList.toggle("hidden")

        this.expandableListTarget.classList.toggle("hidden")
    }
}