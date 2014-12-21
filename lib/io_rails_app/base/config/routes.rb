Rails.application.routes.draw do

  root 'home#index'

  namespace :admin do
    root "base#index"
    resources :users
  end

  if ::Rails.env.production? 
    match '*path', via: :all, to: 'home#error_404'
  end
end
