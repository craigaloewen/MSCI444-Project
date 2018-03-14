Rails.application.routes.draw do

	resources :departments

	resources :users do
		resources :fitbit_data
	end

	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
	get '/logout', to: 'sessions#destroy'

	get '/error', to: 'welcome#error'

	get    '/signup',  to: 'users#new'

	root 'welcome#start_page'
end
