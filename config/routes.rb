Rails.application.routes.draw do
  root "students#index"
  resources :articles
  resources :students
end
