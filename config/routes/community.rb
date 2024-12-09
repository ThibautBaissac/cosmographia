namespace :community do
  resource :directory, only: %i[show], controller: "directory"
end
