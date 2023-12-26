Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html  
  resource :session
  resource :registration
  resource :password
  resource :password_reset 
  get '/list_users', to: 'sessions#list_users'       
  get '/authenticate_with_password', to: 'sessions#authenticate_with_password'  
  get '/authenticate_with_otp', to: 'sessions#authenticate_with_otp'  
  post '/check_users', to: 'sessions#check_users'     
  get '/render_password', to: 'sessions#render_password' 
  get '/render_otp', to: 'sessions#render_otp' 
  get '/new_auth', to: 'sessions#new_auth'  
  get '/login_with_password', to: 'sessions#login_with_password'
  get '/login_with_otp', to: 'sessions#login_with_otp'  
  get '/generate_and_set_otp', to:'sessions#generate_and_set_otp'    
  post '/new_authentication', to:'registrations#new_authentication'
  get '/welcome', to:'sessions#welcome'

  root "main#index"
end
