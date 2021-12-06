Rails.application.routes.draw do

  #Home de la app
  root to: 'home#index' 

  #rutas relacionadas a sesiones
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  #rutas de usuario
  resources :users

  #rutas de profesionales
  resources :professionals do
    #rutas de turnos, estan anidadas dentro de profesionales
    resources :appointments
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
