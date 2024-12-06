require 'faker'

@nb_users = 10
@nb_guest_users = 3
@nb_maps = 300
load(Rails.root.join("db", "seeds", "data", "softwares.rb"))
load(Rails.root.join("db", "seeds", "data", "users.rb"))
load(Rails.root.join("db", "seeds", "data", "guest_users.rb"))
load(Rails.root.join("db", "seeds", "data", "maps.rb"))
load(Rails.root.join("db", "seeds", "data", "feedbacks.rb"))
