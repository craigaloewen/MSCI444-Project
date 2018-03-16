Rails.application.routes.draw do

	resources :departments

	resources :users do
		member do
			get 'hr_dashboard'
			get 'fitbit_data_approval_list'
			get 'fitbit_data_approved_list'
			get 'fitbit_data_disapproved_list'
			get 'generate_report'
			post 'generate_report'
		end
		resources :fitbit_data do
			put 'approve'
			put 'disapprove'
		end
	end

	get '/login', to: 'sessions#new'
	post '/login', to: 'sessions#create'
	delete '/logout', to: 'sessions#destroy'
	get '/logout', to: 'sessions#destroy'

	get '/error', to: 'welcome#error'

	get    '/signup',  to: 'users#new'

	root 'welcome#start_page'
end
