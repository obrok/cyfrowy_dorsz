# Go to http://wiki.merbivore.com/pages/init-rb

# Specify your dependencies in the Gemfile
use_orm :sequel
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '5547b8fc3c8e160f0397ecb1b41fb262e9d6e40c'  # required for cookie session store
  c[:session_id_key] = '_frontend_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  Merb::Authentication.register :form, Merb.root / "merb" / "merb-auth" / "strategies" / "form.rb"
  Merb::Authentication.activate! :form
  
  raise "You need to set Merb::Config[:hostname] for this environment" unless Merb::Config[:hostname]
end
