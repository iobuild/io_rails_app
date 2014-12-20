Rails.application.routes.draw do

  root 'home#index'

  if ::Rails.env.production? 
    match '*path', via: :all, to: 'home#error_404'
  end
end
