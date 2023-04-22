import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["sidebarMenu", "canvasOverlay", "canvasMenu", "closeButton"]
    static values = {
        canvasStart: String,
        canvasEnd: String,
        canvasMenuStart: String,
        canvasMenuEnd: String,
        closeButtonStart: String,
        closeButtonEnd: String,
        duration: Number
    }

    initialize() {
        this.isShown = false
    }

    async startAnimation() {
        if (this.isShown) {
            this.hideTransition()

            await this.timeout(this.durationValue)

            this.sidebarMenuTarget.classList.add("hidden")
        }
        else {
            this.sidebarMenuTarget.classList.remove("hidden")

            await this.nextFrame()
            // await this.timeout(this.durationValue)

            this.showTransition()
        }
        this.isShown = !this.isShown
    }

    hideTransition() {
        this.canvasOverlayTarget.classList.remove(this.canvasEndValue)
        this.canvasOverlayTarget.classList.add(this.canvasStartValue)
        this.canvasMenuTarget.classList.remove(this.canvasMenuEndValue)
        this.canvasMenuTarget.classList.add(this.canvasMenuStartValue)
        this.closeButtonTarget.classList.remove(this.closeButtonEndValue)
        this.closeButtonTarget.classList.add(this.closeButtonStartValue)
    }

    showTransition() {
        this.canvasOverlayTarget.classList.remove(this.canvasStartValue)
        this.canvasOverlayTarget.classList.add(this.canvasEndValue)
        this.canvasMenuTarget.classList.remove(this.canvasMenuStartValue)
        this.canvasMenuTarget.classList.add(this.canvasMenuEndValue)
        this.closeButtonTarget.classList.remove(this.closeButtonStartValue)
        this.closeButtonTarget.classList.add(this.closeButtonEndValue)
    }

    nextFrame() {
        return new Promise(resolve => {
            requestAnimationFrame(() => {
                requestAnimationFrame(resolve)
            })
        })
    }

    timeout(ms) {
        return new Promise(resolve =>{
            setTimeout(resolve, ms)
        })
    }
}