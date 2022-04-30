import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menuIcon", "xIcon", "menuList"]

    initialize() {
        this.isShown = false
        this.menuListTarget.style.display = "none"
    }

    toggle() {
        console.log("toggle")

        this.menuIconTarget.classList.toggle("hidden")
        this.menuIconTarget.classList.toggle("block")

        this.xIconTarget.classList.toggle("hidden")
        this.xIconTarget.classList.toggle("block")

        if (this.isShown)
            this.menuListTarget.style.display = "none"
        else
            this.menuListTarget.style.display = "block"
        this.isShown = !this.isShown
    }
}