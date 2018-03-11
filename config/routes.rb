Rails.application.routes.draw do

	resources :departments

	root 'welcome#start_page'
end
