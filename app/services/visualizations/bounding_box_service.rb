class Visualizations::BoundingBoxService
  def self.call(bbox_param)
    return nil unless bbox_param.present?

    geojson = JSON.parse(bbox_param)
    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    RGeo::GeoJSON.decode(geojson, geo_factory: factory)
  rescue JSON::ParserError
    nil
  end
end
