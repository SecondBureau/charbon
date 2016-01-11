Rails.application.routes.draw do
  mount Charbon::API => '/'
  root 'home#index' 
end
