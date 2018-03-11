Rails.application.routes.draw do

	resources :departments

	resources :users

	root 'welcome#start_page'
end
