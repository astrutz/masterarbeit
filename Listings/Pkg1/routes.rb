Rails.application.routes.draw do
  root 'overview#index'

  localized do
    namespace :sender do
      root 'overview#index'
      get :navigate, to: 'navigate#index'
      get :capacities, to: 'capacities#index'
      get :priorities, to: 'priorities#index'
    end
    # namespace :recipient do
    #
    # end
  end
end