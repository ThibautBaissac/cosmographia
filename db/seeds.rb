require 'faker'

@nb_users = 30
@nb_guest_users = 3
@nb_visualizations = 300
load(Rails.root.join("db", "seeds", "data", "softwares.rb"))
load(Rails.root.join("db", "seeds", "data", "users.rb"))
load(Rails.root.join("db", "seeds", "data", "guest_users.rb"))
load(Rails.root.join("db", "seeds", "data", "visualizations.rb"))
load(Rails.root.join("db", "seeds", "data", "feedbacks.rb"))
