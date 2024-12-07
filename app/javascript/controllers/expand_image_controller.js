import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand-image"
export default class extends Controller {
  static targets = ["expandButton", "imageContainer", "infoSection"];

  toggle() {
    // Toggle classes for the image container
    this.imageContainerTarget.classList.toggle("col-12");
    this.imageContainerTarget.classList.toggle("col-lg-6");

    // Toggle classes for the info section
    this.infoSectionTarget.classList.toggle("col-lg-6");
  }
}
