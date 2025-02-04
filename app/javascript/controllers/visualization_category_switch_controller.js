import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="visualization-category-switch"
export default class extends Controller {
  static targets = [
    "scale",
    "geographicCoverage",
    "projection",
    "map"
  ];

  connect() {
    this.updateFields();
  }

  updateFields() {
    const selectedCategory = document.querySelector('input[name="visualization[category]"]:checked').value;
    if (!selectedCategory) return;

    // Determine if the map-related fields should be active.
    const showMapFields = selectedCategory === "MAP";

    [this.scaleTarget, this.geographicCoverageTarget, this.projectionTarget].forEach(field => {
      this.toggleField(field, showMapFields);
    });
    this.mapTarget.classList.toggle("d-none", !showMapFields);
  }

  toggleField(field, isRequired) {
    field.disabled = !isRequired;
    field.required = isRequired;
    if (!isRequired) {
      field.value = ""; // Reset the field if disabled.
    }
  }
}
