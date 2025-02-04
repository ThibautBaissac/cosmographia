module Constants
  module Visualizations
    VARIANT_SIZES = {
      thumbnail_sm: [ 200, 200 ],
      thumbnail_lg: [ 500, 500 ],
      resized:      [ 1500, 1500 ]
    }.freeze

    CATEGORY = %i[ map data ].freeze
    GEOGRAPHIC_COVERAGE = %i[ local municipal Regional national continental global ].freeze

    PROJECTIONS = %i[
      adams_square_ii
      aitoff
      albers
      aspect_adaptive_cylindrical
      azimuthal_equidistant
      behrmann
      berghaus_star
      bonne
      cassini
      compact_miller
      craster_parabolic
      cube
      cylindrical_equal_area
      double_stereographic
      eckert_i
      eckert_ii
      eckert_iii
      eckert_iv
      eckert_v
      eckert_vi
      eckert_greifendorff
      equal_earth
      equidistant_conic
      equidistant_cylindrical
      fuller
      gall_stereographic
      gauss_kruger
      geostationary_satellite
      gnomonic
      goode_homolosine
      hammer
      hotine_oblique_mercator
      igac_plano_cartesiano
      krovak
      laborde_oblique_mercator
      lambert_azimuthal_equal_area
      lambert_conformal_conic
      local
      loximuthal
      mcbryde_thomas_flat_polar_quartic
      mercator
      miller_cylindrical
      mollweide
      natural_earth
      natural_earth_ii
      new_zealand_national_grid
      ney_modified_conic
      orthographic
      patterson
      peirce_quincuncial
      perspective_cylindrical
      plate_carree
      polyconic
      quartic_authalic
      rectified_skewed_orthomorphic
      robinson
      sinusoidal
      stereographic
      times
      tobler_cylindrical_i
      tobler_cylindrical_ii
      transverse_cylindrical_equal_area
      transverse_mercator
      two_point_equidistant
      van_der_grinten_i
      vertical_near_side_perspective
      wagner_iv
      wagner_v
      wagner_vii
      winkel_i
      winkel_ii
      winkel_tripel
    ].freeze
  end
end
