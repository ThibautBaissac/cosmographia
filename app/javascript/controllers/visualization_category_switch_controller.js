import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="visualization-category-switch"
export default class extends Controller {
  static targets = ["scale", "geographicCoverage", "projection"];

  connect() {
    this.updateFields();
  }

  updateFields(event) {
    const selectedCategory = document.querySelector('input[name="visualization[category]"]:checked').value;

    if (selectedCategory === "MAP") {
      this.toggleField(this.scaleTarget, true);
      this.toggleField(this.geographicCoverageTarget, true);
      this.toggleField(this.projectionTarget, true);
    } else if (selectedCategory === "DATA") {
      this.toggleField(this.scaleTarget, false);
      this.toggleField(this.geographicCoverageTarget, false);
      this.toggleField(this.projectionTarget, false);
    }
  }

  toggleField(field, isRequired) {
    field.disabled = !isRequired;
    field.required = isRequired;
    if (!isRequired) {
      field.value = ""; // Reset value if disabled
    }
  }
}
