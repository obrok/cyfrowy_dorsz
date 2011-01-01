set :application, "cyfrowy_dorsz"
set :repository,  "git@codegarden.icsadl.agh.edu.pl:cyfrowy_dorsz"

set :scm, :git

role :web, "codegarden.icsadl.agh.edu.pl:4000"
role :app, "codegarden.icsadl.agh.edu.pl:4000"
role :db,  "codegarden.icsadl.agh.edu.pl:4000", :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end