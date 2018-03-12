Rails.application.routes.draw do

	resources :departments

	resources :users

	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
	get '/logout', to: 'sessions#destroy'

	get    '/signup',  to: 'users#new'

	root 'welcome#start_page'
end
