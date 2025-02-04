import { Controller } from "@hotwired/stimulus"

const DRAW_OPTIONS = {
  edit: {
    featureGroup: null // to be set at runtime
  },
  draw: {
    polygon: false,
    rectangle: true,
    polyline: false,
    circle: false,
    marker: false,
    circlemarker: false
  }
}

export default class extends Controller {
  static targets = ["boundingBox"]
  static values = {
    boundingBox: String
  }

  connect() {
    this.initMap()
    this.initTileLayer()
    this.initDrawLayerAndControls()
    this.setupDrawEventHandlers()
    this.initializeBoundingBox()
  }

  // -----------------------
  // Initialization Methods
  // -----------------------
  initMap() {
    this.map = L.map(this.element, {
      center: [20, 0],
      zoom: 2,
      worldCopyJump: true
    })
  }

  initTileLayer() {
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(this.map)
  }

  initDrawLayerAndControls() {
    // Create a FeatureGroup to store drawn shapes and add to the map
    this.drawnItems = new L.FeatureGroup().addTo(this.map)

    // Update draw options to use the created drawnItems FeatureGroup
    DRAW_OPTIONS.edit.featureGroup = this.drawnItems

    // Add the drawing controls
    const drawControl = new L.Control.Draw(DRAW_OPTIONS)
    this.map.addControl(drawControl)
  }

  /**
   * Check for bounding box definitions from Stimulus value or URL param.
   * If found, try to parse and display it.
   */
  initializeBoundingBox() {
    const candidates = []

    // Stimulus value takes precedence if provided
    if (this.hasBoundingBoxValue && this.boundingBoxValue !== "null") {
      candidates.push(this.boundingBoxValue)
    }

    // URL parameter as fallback/alternative
    const bboxParam = new URLSearchParams(window.location.search).get("bounding_box")
    if (bboxParam) {
      candidates.push(bboxParam)
    }

    // Use the first valid candidate to set up the bounding box.
    for (const rawGeoJson of candidates) {
      if (this.tryBoundingBox(rawGeoJson)) break
    }
  }

  // -----------------------
  // Event Handlers
  // -----------------------
  setupDrawEventHandlers() {
    this.map.on(L.Draw.Event.CREATED, (event) => {
      this.drawnItems.clearLayers() // Only one shape allowed at a time
      const layer = event.layer
      this.drawnItems.addLayer(layer)
      this.updateHiddenField(layer)
    })

    this.map.on(L.Draw.Event.EDITED, (event) => {
      event.layers.eachLayer((layer) => {
        this.updateHiddenField(layer)
      })
    })

    this.map.on(L.Draw.Event.DELETED, () => {
      this.clearHiddenField()
    })
  }

  // -----------------------
  // Bounding Box Methods
  // -----------------------
  /**
   * Attempts to parse and display the bounding box.
   * Returns true if successful.
   */
  tryBoundingBox(rawGeoJson) {
    const bounds = this.parseGeoJsonBoundingBox(rawGeoJson)
    if (!bounds) return false

    // Draw rectangle from bounds and update the map and hidden field
    const rectangle = L.rectangle(bounds, { color: "#ff7800", weight: 1 })
    this.drawnItems.addLayer(rectangle)
    this.map.fitBounds(bounds)
    this.updateHiddenField(rectangle)
    return true
  }

  /**
   * Parses a GeoJSON string to return Leaflet bounds.
   * Expects a Polygon GeoJSON (only outer ring is used).
   */
  parseGeoJsonBoundingBox(geojsonString) {
    try {
      const decoded = decodeURIComponent(geojsonString)
      const geojson = JSON.parse(decoded)
      if (geojson.type === "Polygon" && Array.isArray(geojson.coordinates)) {
        const coords = geojson.coordinates[0] // Use the outer ring
        // Convert [lng, lat] to Leaflet's [lat, lng]
        const latLngs = coords.map(([lng, lat]) => [lat, lng])
        return L.latLngBounds(latLngs)
      }
    } catch (err) {
      console.error("Invalid GeoJSON bounding box format:", err)
    }
    return null
  }

  // -----------------------
  // Hidden Field Helpers
  // -----------------------
  updateHiddenField(layer) {
    try {
      const geojson = layer.toGeoJSON().geometry
      this.boundingBoxTarget.value = JSON.stringify(geojson)
    } catch (err) {
      console.error("Failed to update bounding box field:", err)
    }
  }

  clearHiddenField() {
    this.boundingBoxTarget.value = ""
  }
}
