import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="list-filter"
export default class extends Controller {
  static targets = ["input", "listItem"]

  filterElements() {
    const query = this.inputTarget.value.trim().toLowerCase()

    this.listItemTargets.forEach((item) => {
      const name = item.dataset.listFilterName.toLowerCase()
      const matches = name.includes(query)
      item.classList.toggle('d-none', !matches)
    })
  }
}
