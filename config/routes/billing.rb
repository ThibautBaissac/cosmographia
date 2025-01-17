namespace :billing do
  resource :subscription, only: [ :show ], controller: :subscription do
    collection do
      post :checkout
    end
  end
end
