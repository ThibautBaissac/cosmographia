import { Controller } from "@hotwired/stimulus"
// import L from "leaflet"
// import "leaflet-draw"

export default class extends Controller {
  static targets = ["boundingBox"]
  static values = {
    boundingBox: String
  }

  connect() {
    // 1. Initialize the map
    this.initMap()

    // 2. Add tile layer
    this.addTileLayer()

    // 3. Create a FeatureGroup to store drawn shapes
    this.drawnItems = new L.FeatureGroup().addTo(this.map)

    // 4. Add drawing controls
    this.addDrawControls()

    // 5. Set up event handlers for create/edit/delete
    this.setupDrawEventHandlers()

    // 6. Attempt to parse a bounding box from the Stimulus value
    if (this.boundingBoxValue && this.boundingBoxValue !== "null") {
      this.tryBoundingBox(this.boundingBoxValue)
    }

    // 7. Attempt to parse a bounding box from URL query param
    const bboxParam = this.getQueryParam("bounding_box")
    if (bboxParam) {
      this.tryBoundingBox(bboxParam)
    }
  }

  // -------------------------
  // Helpers
  // -------------------------
  initMap() {
    this.map = L.map(this.element, {
      center: [20, 0],
      zoom: 2,
      worldCopyJump: true
    })
  }

  addTileLayer() {
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(this.map)
  }

  addDrawControls() {
    const drawControl = new L.Control.Draw({
      edit: {
        featureGroup: this.drawnItems
      },
      draw: {
        polygon: false,
        rectangle: true,
        polyline: false,
        circle: false,
        marker: false,
        circlemarker: false
      }
    })
    this.map.addControl(drawControl)
  }

  setupDrawEventHandlers() {
    // When a new shape is created
    this.map.on(L.Draw.Event.CREATED, (event) => {
      this.drawnItems.clearLayers() // Only one shape allowed
      this.drawnItems.addLayer(event.layer)
      this.updateHiddenField(event.layer)
    })

    // When shapes are edited
    this.map.on(L.Draw.Event.EDITED, (event) => {
      event.layers.eachLayer((layer) => {
        this.updateHiddenField(layer)
      })
    })

    // When shapes are deleted
    this.map.on(L.Draw.Event.DELETED, () => {
      this.clearHiddenField()
    })
  }

  updateHiddenField(layer) {
    const geojson = layer.toGeoJSON().geometry
    this.boundingBoxTarget.value = JSON.stringify(geojson)
  }

  clearHiddenField() {
    this.boundingBoxTarget.value = ""
  }

  getQueryParam(param) {
    return new URLSearchParams(window.location.search).get(param)
  }

  tryBoundingBox(rawGeoJson) {
    const bounds = this.parseGeoJsonBoundingBox(rawGeoJson)
    if (!bounds) return

    const rectangle = L.rectangle(bounds, { color: "#ff7800", weight: 1 })
    this.drawnItems.addLayer(rectangle)
    this.map.fitBounds(bounds)
    this.updateHiddenField(rectangle)
  }

  parseGeoJsonBoundingBox(geojsonString) {
    try {
      const geojson = JSON.parse(decodeURIComponent(geojsonString))
      if (geojson.type === "Polygon" && Array.isArray(geojson.coordinates)) {
        const coords = geojson.coordinates[0] // outer ring
        const latLngs = coords.map(([lng, lat]) => [lat, lng])
        return L.latLngBounds(latLngs)
      }
    } catch (err) {
      console.error("Invalid GeoJSON bounding box format", err)
    }
    return null
  }
}
