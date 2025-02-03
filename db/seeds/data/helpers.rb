def generate_bounding_box(factory)
  min_lon = rand(-130.0..-50.0)
  max_lon = min_lon + rand(5.0..20.0)
  min_lat = rand(10.0..45.0)
  max_lat = min_lat + rand(5.0..20.0)

  polygon = factory.polygon(
    factory.linear_ring([
      factory.point(min_lon, min_lat),
      factory.point(min_lon, max_lat),
      factory.point(max_lon, max_lat),
      factory.point(max_lon, min_lat),
      factory.point(min_lon, min_lat)
    ])
  )

  polygon
end
