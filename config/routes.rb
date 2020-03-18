Rails.application.routes.draw do
  root to: 'home#index'
  get 'json_series', to: 'home#json_series'
end
