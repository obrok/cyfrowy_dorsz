Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  resources :polls do
    resources :questions, :controller => :questions do
      resources :results, :controller => :results
      resources :possible_answers, :controller => :possible_answers
    end

    member :stats, :method => :get
    resources :tokens do
      collection :generate, :method => :get
      collection :save, :method => :post
      collection :delete, :method => :post
      collection :print, :method => :get
    end
  end

  resources :users do
    collection :reset_password, :method => :get
    collection :perform_reset_password, :method => :post
    collection :request_reset_password, :method => :get
    collection :send_reset_password, :method => :post
  end

  resources :answers

  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  default_routes

  match('/').to(:controller => 'polls', :action =>'index')
end
