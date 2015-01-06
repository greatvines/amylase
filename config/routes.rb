Rails.application.routes.draw do

  resources :gooddata_projects

  resources :birst_extract_group_collections

  root 'launched_jobs#index'
  match '/home', to: 'static_pages#home', via: 'get'
  match '/help', to: 'static_pages#help', via: 'get'

  resources :job_specs
  get 'job_specs/:id/run_now', to: 'job_specs#run_now', as: :job_specs_run_now

  resources :tpl_dev_tests, only: [:index, :show, :edit, :update]

  resources :job_schedule_groups

  resource :job_scheduler, only: [:show, :new, :create, :destroy]

  resources :launched_jobs, only: [:index, :show]
  get 'launched_jobs/:id/job_log', to: 'launched_jobs#show_job_log', as: :job_log
  get 'launched_jobs/:id/rerun', to: 'launched_jobs#rerun', as: :launched_job_rerun
  get 'launched_jobs/:id/kill_job', to: 'launched_jobs#kill_job', as: :launched_job_kill_job

  resources :clients
  resources :birst_spaces
  resources :data_sources
  resources :data_source_collections
  resources :birst_process_groups
  resources :birst_process_group_collections
  resources :birst_extract_groups

  get '/job_spec/show_job_template_form' => 'job_specs#show_job_template_form', as: 'show_job_template_form'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
