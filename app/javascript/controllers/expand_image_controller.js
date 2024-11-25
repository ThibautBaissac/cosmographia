import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand-image"
export default class extends Controller {
  static targets = ["expandButton"]

  toggle() {
    this.element.classList.toggle("container")
  }
}
