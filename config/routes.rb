Projectcamp::Application.routes.draw do
  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root to: "bookings#public_index"
  resources :bookings 

  resources :pages, only: [:show, :index]

  get "sessions/login", to: "sessions#login", as: :login
  get "sessions/register", to: "sessions#register", as: :register
  
  
  match 'send_booking_ready_notification' => 'bookings#send_booking_ready_notification', :as => :send_booking_ready_notification, :method => :post 
  match 'close_booking' => 'bookings#close_booking', :as => :close_booking, :method => :post 
  match 'cancel_booking' => 'bookings#cancel_booking', :as => :cancel_booking, :method => :post 
  
  match 'refresh_booking_queue_row' => 'bookings#refresh_booking_queue_row', :as => :refresh_booking_queue_row, :method => :post 
  match 'refresh_public_booking_queue_row' => 'bookings#refresh_public_booking_queue_row', :as => :refresh_public_booking_queue_row, :method => :post 
  
  
  
end


























