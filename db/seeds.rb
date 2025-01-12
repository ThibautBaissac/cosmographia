require 'faker'

@nb_users = 30
@nb_guest_users = 5
@nb_visualizations = 300
@nb_challenges = 30
load(Rails.root.join("db", "seeds", "data", "softwares.rb"))
load(Rails.root.join("db", "seeds", "data", "sources.rb"))
load(Rails.root.join("db", "seeds", "data", "plans.rb"))
load(Rails.root.join("db", "seeds", "data", "users.rb"))
load(Rails.root.join("db", "seeds", "data", "guest_users.rb"))
load(Rails.root.join("db", "seeds", "data", "visualizations.rb"))
load(Rails.root.join("db", "seeds", "data", "feedbacks.rb"))
load(Rails.root.join("db", "seeds", "data", "challenges.rb"))
load(Rails.root.join("db", "seeds", "data", "subscriptions.rb"))
