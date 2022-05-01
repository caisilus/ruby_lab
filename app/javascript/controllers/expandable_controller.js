import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["collapsedIcon", "expandedIcon", "expandableList"]

    initialize() {
        this.isShown = false
    }

    toggle() {
        console.log("toggle")
        this.expandedIconTarget.classList.toggle("hidden")
        this.expandedIconTarget.classList.toggle("block")

        this.collapsedIconTarget.classList.toggle("hidden")
        this.collapsedIconTarget.classList.toggle("block")

        if (this.isShown)
            this.expandableListTarget.classList.add("hidden")
        else
            this.expandableListTarget.classList.remove("hidden")
        this.isShown = !this.isShown
    }
}