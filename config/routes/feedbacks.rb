resources :feedbacks, only: [ :create ]

namespace :admin do
  resources :feedbacks, only: [ :index ]
end
