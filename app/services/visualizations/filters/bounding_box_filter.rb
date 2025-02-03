class Visualizations::Filters::BoundingBoxFilter
  def initialize(params)
    @bounding_box = params[:bounding_box]
  end

  def call(scope)
    return scope unless @bounding_box.present?

    bbox_geojson = JSON.parse(@bounding_box)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    bbox_geometry = RGeo::GeoJSON.decode(bbox_geojson, geo_factory: factory)
    scope.where("ST_Intersects(bounding_box, ST_GeomFromText(?, 4326))", bbox_geometry&.as_text)
  end
end
