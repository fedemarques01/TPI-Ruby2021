Rails.application.routes.draw do
  resources :professionals do
    resources :appointments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
