import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["hideable", "content", "icon"]

  call(event) {
    event.preventDefault()

    this.hideableTarget.classList.toggle("d-none")

    this.contentTarget.classList.toggle("col-md-10")
    this.contentTarget.classList.toggle("col-md-12")

    this.iconTarget.classList.toggle("fa-eye")
    this.iconTarget.classList.toggle("fa-eye-slash")
  }
}
