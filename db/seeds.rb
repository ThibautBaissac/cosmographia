require 'faker'

@nb_users = 15
@nb_guest_users = 10
@nb_visualizations = 50
@nb_challenges = 10
load(Rails.root.join("db", "seeds", "data", "helpers.rb"))
load(Rails.root.join("db", "seeds", "data", "destroy_all.rb"))
load(Rails.root.join("db", "seeds", "data", "softwares.rb"))
load(Rails.root.join("db", "seeds", "data", "sources.rb"))
load(Rails.root.join("db", "seeds", "data", "plans.rb"))
load(Rails.root.join("db", "seeds", "data", "users.rb"))
load(Rails.root.join("db", "seeds", "data", "guest_users.rb"))
load(Rails.root.join("db", "seeds", "data", "visualizations.rb"))
load(Rails.root.join("db", "seeds", "data", "feedbacks.rb"))
load(Rails.root.join("db", "seeds", "data", "challenges.rb"))
load(Rails.root.join("db", "seeds", "data", "subscriptions.rb"))
