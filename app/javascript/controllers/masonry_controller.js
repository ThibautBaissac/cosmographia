import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    // Cache debounced function
    this.debouncedCalculateLayout = this.debounce(this.calculateLayout.bind(this), 200)

    // Wait for all images to load
    this.cacheImages()
      .then(() => {
        this.calculateLayout()
        window.addEventListener("resize", this.debouncedCalculateLayout)
      })
  }

  disconnect() {
    window.removeEventListener("resize", this.debouncedCalculateLayout)
  }

  cacheImages() {
    if (!this.imgCache) {
      this.imgCache = Array.from(this.element.querySelectorAll('img'))
    }

    const imagePromises = this.imgCache.map((img) => {
      if (img.complete) return Promise.resolve()
      return new Promise((resolve) => (img.onload = img.onerror = resolve))
    })

    return Promise.all(imagePromises)
  }

  calculateLayout() {
    const containerWidth = this.element.clientWidth
    const columnCount = this.getColumnCount(containerWidth)
    const columnHeights = Array(columnCount).fill(0)
    const columnWidth = Math.floor((containerWidth - (columnCount - 1) * 10) / columnCount)

    this.element.style.position = "relative"

    this.itemTargets.forEach((item) => {
      const minHeight = Math.min(...columnHeights)
      const columnIndex = columnHeights.indexOf(minHeight)

      // Group transformations for performance
      const x = columnIndex * (columnWidth + 10) // Add horizontal margin spacing
      const y = minHeight

      item.style.cssText = `
        position: absolute;
        width: ${columnWidth}px;
        transform: translate(${x}px, ${y}px);
      `

      columnHeights[columnIndex] += item.offsetHeight + 20 // Add vertical margin spacing
    })

    // Set container height to the tallest column
    const maxHeight = Math.max(...columnHeights)
    this.element.style.height = `${maxHeight}px`
  }

  getColumnCount(width) {
    if (width < 600) return 1
    if (width < 900) return 2
    return 3
  }

  debounce(func, wait) {
    let timeout
    return function (...args) {
      clearTimeout(timeout)
      timeout = setTimeout(() => func.apply(this, args), wait)
    }
  }
}
