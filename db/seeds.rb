require 'faker'

@nb_users = 10
@nb_maps = 100
load(Rails.root.join("db", "seeds", "data", "users.rb"))
load(Rails.root.join("db", "seeds", "data", "maps.rb"))
