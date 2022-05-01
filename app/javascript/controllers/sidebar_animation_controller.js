import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["sidebarMenu", "showingStart", "showingEnd", "hidingStart", "hidingEnd"]

    initialize() {
        this.isShown = false
    }

    startAnimation() {
        console.log("toggle")

        if (this.isShown)
            this.sidebarMenuTarget.classList.add("hidden")
        else
            this.sidebarMenuTarget.classList.remove("hidden")
        this.isShown = !this.isShown
    }
}