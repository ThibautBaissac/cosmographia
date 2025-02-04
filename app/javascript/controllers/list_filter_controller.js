import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="list-filter"
export default class extends Controller {
  static targets = ["input", "listItem"]

  connect() {
    this._cacheListItemNames()
  }

  // Cache the lowercased names from each list item so we don't recalc on every filter.
  _cacheListItemNames() {
    this._cachedItems = this.listItemTargets.map(item => {
      return {
        element: item,
        name: item.dataset.listFilterName.toLowerCase()
      }
    })
  }

  filterElements() {
    const query = this.inputTarget.value.trim().toLowerCase()

    // If there's no query, show all items.
    if (!query) {
      this._cachedItems.forEach(({ element }) => {
        element.classList.remove("d-none")
      })
      return
    }

    this._cachedItems.forEach(({ element, name }) => {
      const matches = name.includes(query)
      element.classList.toggle("d-none", !matches)
    })
  }
}
