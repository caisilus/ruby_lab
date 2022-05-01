import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["collapsedIcon", "expandedIcon", "expandableList"]

    initialize() {
        this.isShown = false
        this.expandableListTarget.style.display = "none"
    }

    toggle() {
        console.log("toggle")
        this.expandedIconTarget.classList.toggle("hidden")
        this.expandedIconTarget.classList.toggle("block")

        this.collapsedIconTarget.classList.toggle("hidden")
        this.collapsedIconTarget.classList.toggle("block")

        if (this.isShown)
            this.expandableListTarget.style.display = "none"
        else
            this.expandableListTarget.style.display = "block"
        this.isShown = !this.isShown
    }
}