# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.




Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  match("/polls/:id/tokens/generate").to(:controller => "tokens", :action => "generate")
  match("/polls/:id/tokens/generate_multi").to(:controller => "tokens", :action => "generate_multi")
  match("/polls/:id/tokens/save").to(:controller => "tokens", :action => "save")

  # RESTful routes
  # resources :posts
  resources :polls do
    resources :questions, :controller => :questions do
      resources :results, :controller => :results
    end

    member :stats, :method => :get
    resources :tokens, :controller => :tokens, :collection => {:generate => :post, :generate_multi => :post, :save => :post, :delete => :post}    
  end

  resources(:users, :collection => {
              :reset_password => :get,
              :perform_reset_password => :post,
              :request_reset_password => :get,
              :send_reset_password => :post
            })

  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  default_routes
  
  # Change this for your home page to be available at /
  match('/').to(:controller => 'polls', :action =>'index')
end
